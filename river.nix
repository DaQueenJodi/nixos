{ config, pkgs, ...}:
let
  repeat = "50 300";
  rofi = "${pkgs.rofi-wayland}/bin/rofi";
  pamixer = "${pkgs.pamixer}/bin/pamixer";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  map = "riverctl map normal";
in {
  imports = [ 
    <home-manager/nixos>
  ];

  home-manager.users.jodi.xdg.configFile."river/init".source = pkgs.writeShellScript "init" ''
  ${map} Super Return spawn foot
  ${map} Super D spawn "${rofi} -show drun -show-icons -monitor -1"
  ${map} Super Q close
  ${map} Super+Shift E exit
  ${map} Super J focus-view next
  ${map} Super K focus-view prev
  ${map} Super+Shift J swap next
  ${map} Super+Shift K swap prev
  ${map} Super Period focus-output next
  ${map} Super Comma  focus-output prev
  ${map} Super+Shift Period send-to-output next
  ${map} Super+Shift Comma  send-to-output prev
  ${map} Super+Shift return Zoom
  ${map} Super H send-layout-cmd rivertile "main-ratio -0.05"
  ${map} Super L send-layout-cmd rivertile "main-ratio +0.05"
  ${builtins.concatStringsSep "\n" (builtins.map (x: 
  let
    tags = "$((1 << ${toString (x - 1) }))";
  in
  ''
  ${map} Super ${toString x} set-focused-tags ${tags}
  ${map} Super+Shift ${toString x} set-view-tags ${tags}
  '')
  [ 1 2 3 4 5 6 7 8 9 ])}

  ${map} Super F toggle-fullscreen

  ${map} None XF86AudioRaiseVolume spawn '${pamixer} -i 5'
  ${map} None XF86AudioLowerVolume spawn '${pamixer} -d 5'
  ${map} None XF86AudioMute        spawn '${pamixer} --toggle-mute'

  ${map} None XF86AudioMedia        spawn '${playerctl} play-pause'
  ${map} None XF86AudioPlay         spawn '${playerctl} play-pause'
  ${map} None XF86AudioPrev         spawn '${playerctl} previous'
  ${map} None XF86AudioNext         spawn '${playerctl} next'

  riverctl set-repeat ${repeat}

  riverctl background-color 0x0


  riverctl default-layout rivertile
  rivertile -view-padding 0 -outer-padding 0 &
  '';
}
