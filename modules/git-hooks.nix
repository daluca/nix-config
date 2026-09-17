{ inputs, ... }:

{
  imports = with inputs; [
    git-hooks.flakeModule
  ];

  perSystem =
    {
      self',
      lib,
      pkgs,
      ...
    }:
    {
      pre-commit.settings = {
        src = ../.;
        hooks = rec {
          check-added-large-files.enable = true;
          check-merge-conflicts.enable = true;
          detect-private-keys.enable = true;
          end-of-file-fixer.enable = true;
          forbid-new-submodules.enable = true;
          trim-trailing-whitespace.enable = true;
          typos.enable = true;
          treefmt.enable = true;
          treefmt.package = self'.formatter;
          deadnix = {
            enable = true;
            settings.edit = true;
          };
          markdownlint-cli2 = {
            enable = true;
            description = "markdownlint-cli2 hook";
            package = pkgs.markdownlint-cli2;
            entry = lib.getExe markdownlint-cli2.package;
            types = [ "markdown" ];
          };
          gitleaks = {
            enable = true;
            description = "gitleaks hook";
            package = pkgs.gitleaks;
            entry = "${lib.getExe gitleaks.package} protect --verbose --redact --staged";
            pass_filenames = false;
          };
          commitlint-rs = {
            enable = false;
            description = "commitlint-rs hook";
            package = pkgs.commitlint-rs;
            entry = "${lib.getExe commitlint-rs.package} --edit";
            stages = [ "prepare-commit-msg" ];
            pass_filenames = false;
            require_serial = true;
            verbose = true;
          };
        };
      };
    };
}
