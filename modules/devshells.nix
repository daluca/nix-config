{ inputs, ... }:

{
  flake.overlays.colmena = final: _prev: {
    colmena = inputs.colmena.packages.${final.stdenv.hostPlatform.system}.colmena;
  };

  perSystem = { self', pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nix-config";
      packages = with pkgs; [
        sops
        git-agecrypt
        just
        deploy-rs
        colmena
      ];
      JUST_COMMAND_COLOR = "blue";
      shellHook = self'.checks.pre-commit.shellHook;
    };
  };
}
