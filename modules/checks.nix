{ self, inputs, ... }:

{
  perSystem =
    {
      system,
      lib,
      pkgs,
      ...
    }:
    {
      checks = {
        pre-commit = inputs.git-hooks.lib.${system}.run {
          src = ../.;
          hooks = import ../.pre-commit-config.nix { inherit lib pkgs; };
        };
        treefmt = (inputs.treefmt.lib.evalModule pkgs ../treefmt.nix).config.build.check self;
      }
      // inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
    };
}
