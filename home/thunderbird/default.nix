{ config, pkgs, ... }:
let
  inherit (pkgs.unstable) thunderbird;
  inherit (config.home) username;
in {
  programs.thunderbird = {
    enable = true;
    package = thunderbird;
    profiles.${username} = {
      isDefault = true;
      settings = {
        "mail.serverDefaultStoreContractID" = "@mozilla.org/msgstore/maildirstore;1";
      };
    };
  };
}
