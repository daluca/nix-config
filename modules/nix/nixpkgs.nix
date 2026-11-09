{
  self,
  inputs,
  withSystem,
  ...
}:

{
  perSystem = { lib, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays =
        with inputs;
        builtins.attrValues (lib.filterAttrs (key: _value: !lib.hasSuffix "-unstable" key) self.overlays)
        ++ [
          nur.overlays.default
          nix-vscode-extensions.overlays.default
        ];
    };
  };

  flake.overlays.nixpkgs =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { system, ... }: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = builtins.attrValues (
            prev.lib.filterAttrs (key: _value: prev.lib.hasSuffix "-unstable" key) self.overlays
          );
        };
      }
    );
}
