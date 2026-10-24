{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = with config; [
          pre-commit.devShell
          terranix.terranixConfigurations.cloud.result.devShell
        ];
        name = "nix-config";
        packages = with pkgs; [
          sops
          git-agecrypt
          just
          deploy-rs
          # TODO: Revert to stable branch in NixOS 26.11
          unstable.colmena
          unstable.secretspec
        ];
        JUST_COMMAND_COLOR = "blue";
      };
    };
}
