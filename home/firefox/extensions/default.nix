{
  imports = [
    ./ublock-origin.nix
    ./bitwarden.nix
    ./sponsorblock.nix
    ./multi-account-containers.nix
    ./stylus.nix
    ./decentraleyes.nix
    ./simplelogin.nix
    ./clearurls.nix
    ./bypass-paywalls-clean.nix
    ./linkwarden.nix
  ];

  programs.firefox.policies = {
    ExtensionSettings."*".installation_mode = "blocked";
    ExtensionUpdate = false;
  };
}
