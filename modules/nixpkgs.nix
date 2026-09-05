{
  self,
  inputs,
  withSystem,
  ...
}:

{
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays =
        with inputs;
        builtins.attrValues self.overlays
        ++ [
          nur.overlays.default
          nix-vscode-extensions.overlays.default
          proton-ge.overlays.default
        ];
      config.allowUnfree = true;
    };
  };

  flake.overlays.nixpkgs-unstable =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { system, ... }: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      }
    );
}
