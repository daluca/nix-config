{ config, lib, pkgs, ... }:
let
  cfg = config.services.attic-watch-store;
in with lib; {
  options.services.attic-watch-store = {
    enable = lib.mkEnableOption "attic-watch-store";

    package = lib.mkPackageOption pkgs "attic-client" { };

    apiTokenFile = lib.mkOption {
      type = types.pathWith {
        absolute = true;
        inStore = false;
      };
      description = "The path to a file containing Attic API token";
    };

    cache = lib.mkOption {
      type = types.submodule {
        options = {
          endpoint = lib.mkOption {
            type = types.str;
            description = "Endpoint for the Attic server";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.attic-watch-store = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment.HOME = "/var/lib/attic-watch-store";
      serviceConfig = {
        DynamicUser = true;
        MemoryHigh = "5%";
        MemoryMax = "10%";
        LoadCredential = "api-token:${cfg.apiTokenFile}";
        StateDirectory = "attic-watch-store";
      };
      path = with pkgs; [
        attic-client
      ];
      script = /* bash */ ''
        set -euo pipefail

        ATTIC_TOKEN="$(< "''${CREDENTIALS_DIRECTORY}/api-token")"

        attic login central ${cfg.cache.endpoint} "''${ATTIC_TOKEN}"
        attic use central:production

        exec attic watch-store central:production
      '';
    };
  };
}
