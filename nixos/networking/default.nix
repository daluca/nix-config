{ config, lib, pkgs, ... }:

{
  networking.domain = "internal";

  # TODO: Remove when upstream resolves issue
  # Workaround to remove --wait-for-startup flag
  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };

  environment.persistence.system.directories = lib.mkIf config.networking.networkmanager.enable [
    "/etc/NetworkManager/system-connections"
  ];
}
