{ lib, pkgs }:

rec {
  check-added-large-files.enable = true;
  check-merge-conflicts.enable = true;
  detect-private-keys.enable = true;
  end-of-file-fixer.enable = true;
  forbid-new-submodules.enable = true;
  trim-trailing-whitespace.enable = true;
  yamllint.enable = true;
  yamlfmt.enable = true;
  typos.enable = true;
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
  toml-sort = {
    enable = true;
    description = "toml-sort hook";
    package = pkgs.writeShellScriptBin "toml-sort" /* bash */ ''
      set -euo pipefail

      VALID_FILES=()

      for toml in "$@"; do
        [[ "$( ${lib.getExe pkgs.file} "''${toml}" )" =~ ASCII ]] && VALID_FILES+=( "''${toml}" )
      done

      ${lib.getExe pkgs.toml-sort} --trailing-comma-inline-array --in-place --all "''${VALID_FILES[@]}"
    '';
    entry = lib.getExe toml-sort.package;
    types = [ "toml" ];
    excludes = [
      "Cargo.lock"
    ];
  };
}
