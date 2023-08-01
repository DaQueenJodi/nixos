# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./wayland.nix
      ./wifi.nix
      ./home.nix
      ./persistence.nix
      ./gpu.nix
    ];

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "America/Chicago";


    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    environment.variables = {
      EDITOR = "nvim";
      NIX_SHELL_PRESERVE_PROMPT = "1";
    };

    users.mutableUsers = false;
    users.users.root.initialPassword = "1234five";
    users.users.jodi = {
      initialPassword = "1234five";
      isNormalUser = true;
      extraGroups = [
        "audio"
        "plugdev"
        "input"
        "video"
        "wheel"
      ];
      packages = with pkgs; [
        github-cli
        qbittorrent
        rofi-wayland
        river
        foot
        neovim
        firefox
        steam
        pavucontrol
        tuxpaint
        (lutris.override {
          extraPkgs = pkgs: with pkgs.gst_all_1; [
            # required for jc141
            wineWowPackages.waylandFull
            # required for icons
            gnome3.adwaita-icon-theme

            # recommended for jc141
            gst-libav
            gst-plugins-bad
            gst-plugins-base
            gst-plugins-good
            gst-plugins-ugly
            gst-vaapi
          ];
        })
        obs-studio
        gimp

      ];
    };

    environment.systemPackages = with pkgs; [
      git
      killall
      file
      wget
    ];

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.openssh = {
      enable = true;
      openFirewall = true;
      allowSFTP = true;
    };

    fonts.fonts = with pkgs; [
      noto-fonts
      fira-code
      dejavu_fonts
    ];


    programs.bash = {
      enableCompletion = true;
    };

    system.stateVersion = "23.05"; # Did you read the comment?

  }

