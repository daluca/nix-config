{ config, secrets, ... }:
let
  inherit (config) sops;
  inherit (secrets.email) proton hotmail gmail;
  realName = "Lucas Slebos";
  thunderbird = {
    enable = true;
    settings = id: {
      "mail.smtpserver.smtp_${id}.authMethod" = /* OAuth2 */ 10;
      "mail.server.server_${id}.authMethod" = /* OAuth2 */ 10;
    };
  };
in {
  accounts.email.accounts = {
    ${proton.primary} = rec {
      inherit realName;
      primary = true;
      address = proton.primary;
      userName = address;
      passwordCommand = "cat ${sops.secrets."proton-bridge/password".path}";

      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      thunderbird.enable = true;
    };

    ${hotmail.primary} = {
      inherit realName thunderbird;
      address = hotmail.primary;
      flavor = "outlook.office365.com";
    };

    ${gmail.primary} = {
      inherit realName thunderbird;
      address = gmail.primary;
      flavor = "gmail.com";
      passwordCommand = "cat ${sops.secrets."gmail/primary/password".path}";
    };

    ${hotmail.secondary} = {
      inherit realName thunderbird;
      address = hotmail.secondary;
      flavor = "outlook.office365.com";
    };

    ${gmail.secondary} = {
      inherit realName thunderbird;
      address = gmail.secondary;
      flavor = "gmail.com";
    };
  };

  sops.secrets."gmail/primary/password" = { };
}
