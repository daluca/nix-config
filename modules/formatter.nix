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
      programs.yamllint.enable = true;
      programs.yamlfmt.enable = true;
      settings.excludes = [
        "*/secrets.toml"
      ];
    };
  };
}
