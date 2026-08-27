{
  perSystem = { self', inputs', pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nix-config";
      packages = with pkgs; [
        sops
        git-agecrypt
        just
        deploy-rs
        inputs'.colmena.packages.colmena
      ];
      JUST_COMMAND_COLOR = "blue";
      shellHook = self'.checks.pre-commit.shellHook;
    };
  };
}
