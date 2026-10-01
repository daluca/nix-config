{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [
          config.pre-commit.devShell
        ];
        name = "nix-config";
        packages = with pkgs; [
          sops
          git-agecrypt
          just
          deploy-rs
          # TODO: Revert to stable branch in NixOS 26.11
          unstable.colmena
        ];
        JUST_COMMAND_COLOR = "blue";
      };
    };
}
