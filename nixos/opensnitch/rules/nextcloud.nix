{ config, lib, ... }:

{
  services.opensnitch.rules = {
    nextcloud = lib.mkIf config.home-manager.users.daluca.services.nextcloud-client.enable rec {
      name = "nextcloud";
      enabled = true;
      action = "allow";
      duration = "always";
      operator = {
        type = "list";
        operand = "list";
        data = "${builtins.toJSON operator.list}";
        list = [
          {
            type = "simple";
            operand = "process.path";
            data = "${config.home-manager.users.daluca.services.nextcloud-client.package}/bin/.nextcloud-wrapped";
          }
          {
            type = "regexp";
            operand = "dest.port";
            data = "^(53|443)$";
          }
          {
            type = "regexp";
            operand = "dest.host";
            data = "^(sso|cloud).daluca.io$";
          }
        ];
      };
    };
  };
}
