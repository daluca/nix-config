{ config, lib, ... }:
let
  inherit (lib.path) append;
  inherit (config.networking) hostName domain;
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

  programs.ssh.knownHosts = rec {
    artemis = {
      extraHostNames = [ "artemis.${domain}" "10.1.127.236" ];
      publicKeyFile = ../../hosts/artemis/keys/ssh_host_ed25519_key.pub;
    };
    "artemis/rsa" = {
      hostNames = [ "artemis" ] ++ artemis.extraHostNames;
      publicKeyFile = ../../hosts/artemis/keys/ssh_host_rsa_key.pub;
    };
    stormwind = {
      extraHostNames = [ "storwind.${domain}" "10.0.0.10" ];
      publicKeyFile = ../../hosts/stormwind/keys/ssh_host_ed25519_key.pub;
    };
    "stormwind/rsa" = {
      hostNames = [ "stormwind" ] ++ stormwind.extraHostNames;
      publicKeyFile = ../../hosts/stormwind/keys/ssh_host_rsa_key.pub;
    };
    ironforge = {
      extraHostNames = [ "ironforge.${domain}" "192.168.1.232" ];
      publicKeyFile = ../../hosts/ironforge/keys/ssh_host_ed25519_key.pub;
    };
    "ironforge/rsa" = {
      hostNames = [ "ironforge" ] ++ ironforge.extraHostNames;
      publicKeyFile = ../../hosts/ironforge/keys/ssh_host_rsa_key.pub;
    };
    darnassus = {
      extraHostNames = [ "darnassus.${domain}" "10.2.74.60" ];
      publicKeyFile = ../../hosts/darnassus/keys/ssh_host_ed25519_key.pub;
    };
    "darnassus/rsa" = {
      hostNames = [ "darnassus" ] ++ darnassus.extraHostNames;
      publicKeyFile = ../../hosts/darnassus/keys/ssh_host_rsa_key.pub;
    };
    azeroth = {
      extraHostNames = [ "azeroth.${domain}" "10.1.219.30" ];
      publicKeyFile = ../../hosts/azeroth/keys/ssh_host_ed25519_key.pub;
    };
    "azeroth/rsa" = {
      hostNames = [ "azeroth" ] ++ azeroth.extraHostNames;
      publicKeyFile = ../../hosts/azeroth/keys/ssh_host_rsa_key.pub;
    };
    gainas = {
      extraHostNames = [ "gainas.${domain}" "10.2.161.172" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF485Ey6FSRpM/6BnEiN+RXWoKln5YszVumSuCnUc9ae root@gainas";
    };
    "gainas/rsa" = {
      hostNames = [ "gainas" ] ++ gainas.extraHostNames;
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsPlgTOVoTkGVDO4lyqbFOuuJfx8+xmccHZ/R2nC7QMrN7N5d1cYeKNL9pSBC4Eg0+Sco1wOR/ASqziWvu51jAEmkAG3bdf7Jy587xoIROe80ZYow3F5o0tto4gI7InkQBwwjMt7ZMw3/92aYaRyZk9BjCUeHXGdePS54bF9KH70l8o7KtvoEyLrI2A5O+uucmz3nfGym9YSulUmWXT8HcWDRLxVkw4cJ5e1rptuxNIkiayTSBcdRjvIVBfwjmMFMFBtFaHY29nv63A21jw5gxSGkDe/QzEt8JCtjbTpp6XJtYdOGUhpTcSFPG4DAAPU4IjveHRW1xLVvFbqtO0z4S2gnDXex4HEC/2MALxuv81i01U30o75isl2rsWBkBwTzVi2odO5PZ3Y51kYdHgjLHh0VPLxSvCa0v4lZ0yuM2jE0DZWrbSSrlZVvQStJdVbquidLLtrD69CH4MKzA8H2cbX0Oyos6bjyLEbt5o+qUvKdlFwGonkMUpk0E+ig3jdE= root@gainas";
    };
  };
}
