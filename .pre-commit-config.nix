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
  deadnix = {
    enable = true;
    settings.edit = true;
  };
  typos = {
    enable = true;
    settings.configPath = "typos.toml";
    args = [ "--force-exclude" ];
  };
  markdownlint-cli2 = {
    enable = true;
    description = "markdownlint-cli2 hook";
    package = pkgs.markdownlint-cli2;
    entry = "${markdownlint-cli2.package}/bin/markdownlint-cli2";
    types = [ "markdown" ];
  };
  gitleaks = {
    enable = true;
    description = "gitleaks hook";
    package = pkgs.gitleaks;
    entry = "${gitleaks.package}/bin/gitleaks protect --verbose --redact --staged";
    pass_filenames = false;
    excludes = [
      "secrets.toml"
    ];
  };
  commitlint-rs = {
    enable = false;
    description = "commitlint-rs hook";
    package = pkgs.commitlint-rs;
    entry = "${commitlint-rs.package}/bin/commitlint --edit";
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
