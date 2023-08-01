{ config, pkgs, lib, ...}:
let
  autostart = [
    "steam -silent %U"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway"
    "systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr"
    "systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr"
  ];
  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  resize = "10";
  volstep = "5";
  concatLines = builtins.concatStringsSep "\n";
  term = "${pkgs.foot}/bin/foot";
  rofi = "${pkgs.rofi-wayland}/bin/rofi";
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  switch = "${pkgs.writeShellScript "switch" ''
  MON=$(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] |  select(.focused==true) | .name')
  case $MON in
    "${mon2}")
      MONADD=0
      ;;
    "${mon1}")
      MONADD=10
      ;;
  esac
  swaymsg $2 workspace number $(($MONADD + $1))
  ''}";
  mod = "Mod4";
  mon1 = "DVI-D-1";
  mon2 = "HDMI-A-2";
in {

  imports = [ ./wayland.nix ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  home-manager.users.jodi.xdg.configFile."sway/config".text = 
  ''
  output ${mon1}  resolution 1280x1024 position 1920 0
  output ${mon2} resolution 1920x1080 position 0 0 



  input type:keyboard {
    repeat_delay 300
    repeat_rate 45
    xkb_options ctrl:nocaps
  }

  # disable title bar
  default_border          pixel 2
  default_floating_border pixel 2

  hide_edge_borders smart

  bindsym ${mod}+Shift+q kill

  bindsym ${mod}+d       exec ${rofi}     -show drun -show-icons -monitor -1
  bindsym ${mod}+Return  exec ${term}
  bindsym ${mod}+Shift+s exec ${grimshot} copy area
  bindsym Print          exec ${grimshot} copy active
  bindSym ${mod}+Print   exec ${grimshot} copy output


  bindsym XF86AudioRaiseVolume exec ${pamixer} -i ${volstep}
  bindsym XF86AudioLowerVolume exec ${pamixer} -d ${volstep}
  bindsym XF86AudioMute        exec ${pamixer} --toggle-mute

  bindsym XF86AudioMedia exec ${playerctl} play-pause
  bindsym XF86AudioPlay  exec ${playerctl} play-pause
  bindsym XF86AudioNext  exec ${playerctl} next
  bindsym XF86AudioPrev  exec ${playerctl} prev


  bindsym ${mod}+Shift+c    reload
  bindsym ${mod}+Shift+e    exec swaymsg exit

  bindsym ${mod}+h          focus left
  bindsym ${mod}+Shift+h    move  left
  bindsym ${mod}+j          focus down
  bindsym ${mod}+Shift+j    move  down
  bindsym ${mod}+k          focus up
  bindsym ${mod}+Shift+k    move  up
  bindsym ${mod}+l          focus right
  bindsym ${mod}+Shift+l    move  right


  bindsym ${mod}+Comma        focus output left
  bindsym ${mod}+Shift+Comma  move  output left
  bindsym ${mod}+Period       focus output right
  bindsym ${mod}+Shift+Period move  output right

  ${concatLines (map (x: 
  let 
    key = if x == 10 then 0 else x;
  in
  ''
  workspace ${toString x} output ${mon2}
  workspace ${toString (x + 10)} output ${mon1}

  bindsym ${mod}+${toString key} exec ${switch} ${toString x}
  bindsym ${mod}+Shift+${toString key} exec ${switch} ${toString x} "move container to"
  '') (lib.lists.range 1 10))}

  bindsym ${mod}+s splitv
  bindsym ${mod}+v splith

  bindsym ${mod}+f fullscreen

  bindsym ${mod}+Alt+h resize shrink width  ${resize}px
  bindsym ${mod}+Alt+j resize grow   height ${resize}px
  bindsym ${mod}+Alt+k resize shrink height ${resize}px
  bindsym ${mod}+Alt+l resize grow   width  ${resize}px



  ${concatLines (map (x: "exec ${x}") autostart)}
  '';
}
