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
      programs.shellcheck.enable = true;
      programs.toml-sort.enable = true;
      settings.formatter.toml-sort = {
        excludes = [
          "*/secrets.toml"
        ];
      };
    };
  };
}
