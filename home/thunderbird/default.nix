{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.unstable.thunderbird;
    profiles.default = {
      isDefault = true;
      settings = {
        "mail.serverDefaultStoreContractID" = "@mozilla.org/msgstore/maildirstore;1";
      };
    };
  };

  xdg.mimeApps.defaultApplicationPackages = [
    config.programs.thunderbird.package
  ];

  home.persistence.home.directories = [
    ".thunderbird"
  ];
}
