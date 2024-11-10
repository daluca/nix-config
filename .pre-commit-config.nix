{ nixpkgs, system }:

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
    package = nixpkgs.legacyPackages.${system}.markdownlint-cli2;
    entry = "${markdownlint-cli2.package}/bin/markdownlint-cli2";
    types = [ "markdown" ];
  };
  codespell = {
    enable = true;
    name = "codespell";
    description = "Checks for common misspellings in text files.";
    package = nixpkgs.legacyPackages.${system}.codespell;
    entry = "${codespell.package}/bin/codespell";
    types = [ "text" ];
  };
  gitleaks = {
    enable = true;
    name = "Detect hardcoded secrets";
    description = "Detect hardcoded secrets using Gitleaks";
    package = nixpkgs.legacyPackages.${system}.gitleaks;
    entry = "${gitleaks.package}/bin/gitleaks protect --verbose --redact --staged";
    pass_filenames = false;
  };
  check-github-workflows = {
    enable = false;
    name = "Validate GitHub Workflows";
    description = "Validate GitHub Workflows against the schema provided by SchemaStore";
    package = nixpkgs.legacyPackages.${system}.check-jsonschema;
    entry = "${check-github-workflows.package}/bin/check-jsonschema --builtin-schema vendor.github-workflows";
    args = [
      "--verbose"
    ];
    types = [ "yaml" ];
    files = "^\\.github/workflows/[^/]+$";
  };
}
