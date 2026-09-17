{ self, ... }:

{
  flake.homeManagerModules.thunderbird = { config, ... }: {
    imports = with self.homeManagerModules; [
      protonmail-bridge
    ];

    programs.thunderbird = {
      enable = true;
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
  };
}
