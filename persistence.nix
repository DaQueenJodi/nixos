{config, pkgs, ...}:
let
  impermanence = builtins.fetchTarball {
    url = "https://github.com/nix-community/impermanence/archive/master.tar.gz";
  };
in {
  imports = [
    "${impermanence}/nixos.nix"
  ];

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/var/lib/jellyfin"
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];
    files = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

}
