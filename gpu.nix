{ config, pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];



  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
