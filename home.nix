{ config, pkgs, ...}:
{
  imports = [
    <home-manager/nixos>
    #./river.nix
    ./sway.nix
  ];

  home-manager.users.jodi = {pkgs, ...}: {
    home.stateVersion = "23.05";
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        PS1="\w\$ "
      '';
      shellAliases = {
        ls = "ls --color=auto";
        vim = "nvim";
        nz = "nix-shell";
        nzp = "nix-shell -p";
      };
    };
    services.kanshi = {
      enable = true;
      profiles = {
        docked = {
          outputs = [
            {
              criteria = "HDMI-A-4";
              position = "0,0";
            }
            {
              criteria = "DVI-D-1";
              position = "1920,0";
            }
          ];
        };
      };
    };
    programs.foot = {
      enable = true;
      settings = {
        main = {
          include = "${pkgs.foot.src}/themes/gruvbox-dark";
          dpi-aware = "no";
          font = "monospace:size=10";
        };
      };
    };
  };

}
