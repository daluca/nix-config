{ config, pkgs, secrets, ... }:
let
  inherit (secrets) gmail;
  oauth2 = 10;
in {
  accounts.email.accounts."${gmail.primary.username}@gmail.com" = rec {
    primary = true;
    realName = "Lucas Slebos";
    userName = gmail.primary.username;
    address = "${userName}@${flavor}";
    flavor = "gmail.com";
    passwordCommand = "cat ${config.sops.secrets."gmail/primary/password".path}";

    thunderbird = {
      enable = false;
      settings = id: {
        "mail.smtpserver.smtp${id}.authMethod" = oauth2;
        "mail.server.server${id}.authMethod" = oauth2;
      };
    };
  };

  sops.secrets."gmail/primary/password" = { };
}
