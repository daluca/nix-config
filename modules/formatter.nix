{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    formatter = (inputs.treefmt.lib.evalModule pkgs ../treefmt.nix).config.build.wrapper;
  };
}
