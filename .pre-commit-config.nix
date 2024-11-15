{ pkgs }:

rec {
  check-added-large-files.enable = true;
  check-merge-conflicts.enable = true;
  detect-private-keys.enable = true;
  end-of-file-fixer.enable = true;
  forbid-new-submodules.enable = true;
  trim-trailing-whitespace.enable = true;
  yamllint.enable = false;
  markdownlint-cli2 = {
    enable = true;
    name = "markdownlint-cli2";
    description = "Checks the style of Markdown/CommonMark files.";
    package = pkgs.markdownlint-cli2;
    entry = "${markdownlint-cli2.package}/bin/markdownlint-cli2";
    types = [ "markdown" ];
  };
  codespell = {
    enable = true;
    name = "codespell";
    description = "Checks for common misspellings in text files.";
    package = pkgs.codespell;
    entry = "${codespell.package}/bin/codespell";
    types = [ "text" ];
  };
  gitleaks = {
    enable = true;
    name = "Detect hardcoded secrets";
    description = "Detect hardcoded secrets using Gitleaks";
    package = pkgs.gitleaks;
    entry = "${gitleaks.package}/bin/gitleaks protect --verbose --redact --staged";
    pass_filenames = false;
  };
  commitlint-rs = {
    enable = false;
    name = "Assert Conventional Commit Messages";
    description = "Asserts that Conventional Commits have been used for all commit messages according to the rules for this repo.";
    package = pkgs.commitlint-rs;
    entry = "${commitlint-rs.package}/bin/commitlint --edit";
    stages = [ "prepare-commit-msg" ];
    pass_filenames = false;
    require_serial = true;
    verbose = true;
  };
}
