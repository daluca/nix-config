{ config, lib, pkgs, ... }:

{
  services.atticd = {
    enable = true;
    environmentFile = config.sops.templates."atticd.env".path;
  };

  sops.templates."atticd.env" = {
    content = lib.generators.toKeyValue { } {
      ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64 = config.sops.placeholder."atticd/token";
    };
  };

  environment.systemPackages = with pkgs; [
    attic-server
  ];

  environment.persistence.system.directories = [
    { directory = "/var/lib/private/atticd"; mode = "0700"; }
  ];
}
