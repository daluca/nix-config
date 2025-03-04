{ pkgs, ... }:

{
  imports = [
    ./keys
  ];

  programs.gpg = {
    enable = true;
    # NOTE: homedir breaks smart-cards
    # homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = false;
    settings = {
      armor = true;
      fixed-list-mode = false;
      no-greeting = true;
      throw-keyids = true;
    };
    scdaemonSettings = {
      disable-ccid = true;
      reader-port = "Yubico Yubi";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  home.persistence.home.directories = [
    ".gnupg"
  ];
}
