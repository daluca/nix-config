{ inputs, ... }:

{
  imports = with inputs; [
    treefmt.flakeModule
  ];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.nixfmt.enable = true;
      programs.just.enable = true;
    };
  };
}
