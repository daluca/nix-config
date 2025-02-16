{
  imports = [
    ../../images/digitalocean

    ../../nixos/common
    ../../nixos/openssh/server
    ../../nixos/unifi-controller
  ];

  networking.hostName = "unifi";
  networking.enableIPv6 = false;

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./unifi.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./unifi.sops.yaml;

  system.stateVersion = "24.11";
}
