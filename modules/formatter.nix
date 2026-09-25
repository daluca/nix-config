{ inputs, ... }:

{
  imports = with inputs; [
    treefmt.flakeModule
  ];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs.deadnix.enable = true;
      programs.nixfmt.enable = true;
      programs.just.enable = true;
      programs.shellcheck.enable = true;
      programs.statix.enable = true;
      programs.toml-sort.enable = true;
      programs.yamllint.enable = true;
      programs.yamlfmt.enable = true;
      settings.formatter.toml-sort = {
        includes = [
          ".typos.toml"
        ];
        excludes = [
          "git-agecrypt.toml"
        ];
      };
      settings.excludes = [
        "*/secrets.toml"
      ];
    };
  };
}
