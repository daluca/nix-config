{ config, lib, ... }:

{
  boot = {
    initrd = {
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22022;
          authorizedKeyFiles = [
            (lib.custom.relativeToUsers "daluca/keys/id_ed25519.pub")
          ];
          hostKeys = [
            "/etc/ssh/ssh_initrd_ed25519_key"
            "/etc/ssh/ssh_initrd_rsa_key"
          ];
          shell = "/bin/cryptsetup-askpass";
        };
      };
    };
  };

  environment.etc."ssh/ssh_initrd_ed25519_key" = {
    source = config.sops.secrets."ssh_initrd_ed25519_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_initrd_ed25519_key".key = "initrd_id_ed25519";

  environment.etc."ssh/ssh_initrd_ed25519_key.pub".source = lib.custom.relativeToHosts "${config.networking.hostName}/keys/ssh_initrd_ed25519_key.pub";

  environment.etc."ssh/ssh_initrd_rsa_key" = {
    source = config.sops.secrets."ssh_initrd_rsa_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_initrd_rsa_key".key = "initrd_id_rsa";

  environment.etc."ssh/ssh_initrd_rsa_key.pub".source = lib.custom.relativeToHosts "${config.networking.hostName}/keys/ssh_initrd_rsa_key.pub";
}
