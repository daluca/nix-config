{ config, lib, ... }:

{
  services.opensnitch.rules = {
    firefox = lib.mkIf config.home-manager.users.daluca.programs.firefox.enable rec {
      name = "firefox";
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
            data = "${config.home-manager.users.daluca.programs.firefox.finalPackage}/lib/firefox/firefox";
          }
          {
            type = "regexp";
            operand = "dest.port";
            data = "^(53|80|443)$";
          }
          {
            type = "simple";
            operand = "user.id";
            data =
              if config.users.users.daluca.uid == null then
                "1000"
              else
                "${config.users.users.daluca.uid}";
          }
        ];
      };
    };
  };
}
