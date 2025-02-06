{ config, lib, ... }:
let
  inherit (lib.path) append;
  inherit (config.networking) hostName;
  inherit (config.sops) secrets;
in {
  environment.etc."ssh/ssh_host_ed25519_key.pub".source = append ../../hosts "${hostName}/keys/ssh_host_ed25519_key.pub";

  environment.etc."ssh/ssh_host_ed25519_key" = {
    source = secrets."ssh_host_ed25519_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_host_ed25519_key".key = "id_ed25519";

  environment.etc."ssh/ssh_host_rsa_key.pub".source = append ../../hosts "${hostName}/keys/ssh_host_rsa_key.pub";

  environment.etc."ssh/ssh_host_rsa_key" = {
    source = secrets."ssh_host_rsa_key".path;
    mode = "0400";
  };

  sops.secrets."ssh_host_rsa_key".key = "id_rsa";
}
