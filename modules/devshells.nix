{
  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inherit (self'.checks.pre-commit) shellHook;
        name = "nix-config";
        packages =
          with pkgs;
          self'.checks.pre-commit.enabledPackages
          ++ [
            sops
            git-agecrypt
            just
            deploy-rs
            colmena
          ];
        JUST_COMMAND_COLOR = "blue";
      };
    };
}
