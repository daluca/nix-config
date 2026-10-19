{ self, ... }:

{
  flake.homeModules.nix-inspect = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      nix-inspect
    ];

    xdg.configFile."nix-inspect/config.json".text = builtins.toJSON {
      bookmarks =
        lib.mapAttrsToList (hostname: _nixos: {
          display = hostname;
          path = "nixosConfigurations.${hostname}";
        }) self.nixosConfigurations
        ++ lib.mapAttrsToList (username: _homeManager: {
          display = username;
          path = "nixosConfigurations.benedick.config.home-manager.users.${username}";
        }) self.nixosConfigurations.benedick.config.home-manager.users;
    };
  };
}
