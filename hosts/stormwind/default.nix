{
  imports = [
    ../../images/raspberry-pi/4

    ../.
    ../../nixos/openssh/server
    ../../nixos/tailscale/server
    ../../nixos/adguardhome

    ./adguardhome.nix
  ];

  nix.settings.trusted-users = [ "@wheel" ];

  services.getty.autologinUser = "daluca";

  networking.hostName = "stormwind";

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./stormwind.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./stormwind.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./stormwind.sops.yaml;

  services.tailscale.extraUpFlags = [
    "--advertise-routes=10.0.0.0/14"
    "--hostname=akaroa"
  ];

  hardware.raspberry-pi.config.pi4 = {
    dt-overlays.rpi-poe = {
      enable = true;
      params = {
        poe_fan_temp0 = { enable = true; value = 65 * 1000; };
        poe_fan_temp1 = { enable = true; value = 70 * 1000; };
        poe_fan_temp2 = { enable = true; value = 75 * 1000; };
        poe_fan_temp3 = { enable = true; value = 80 * 1000; };
      };
    };
  };

  system.stateVersion = "24.11";
}
