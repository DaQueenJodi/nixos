{config, pkgs, ...}:
{
  users.users.jodi.extraGroups = [ "network" ];
  networking.networkmanager.enable = true;
  # wifi adapter drivers
  boot.extraModulePackages = with config.boot.kernelPackages; [
    (rtl88x2bu.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "RinCat";
        repo = "RTL88x2BU-Linux-Driver";
        rev = "12cfcd8";
        sha256 = "c27g1xix+FDq5CwegPxHPpNqQ2ZiEXOxXNB1YumNslU=";
      };
    }))
  ];
  boot.kernelModules = [ "r88x2bu" ];
}
