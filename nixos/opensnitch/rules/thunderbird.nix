{ config, lib, ... }:

{
  services.opensnitch.rules = {
    thunderbird = lib.mkIf config.home-manager.users.daluca.programs.thunderbird.enable rec {
      name = "thunderbird";
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
            data = "${config.home-manager.users.daluca.programs.thunderbird.package}/lib/thunderbird/thunderbird";
          }
          {
            type = "regexp";
            operand = "dest.port";
            data = "^(443|993)$";
          }
          {
            type = "regexp";
            operand = "dest.host";
            data = "^(login.microsoftonline.com|outlook.office365.com)$";
          }
        ];
      };
    };
  };
}
