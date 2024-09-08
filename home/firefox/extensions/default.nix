{ ... }:

{
  # TODO: Firefox policy extension setting to install extensions
  imports = [
    ./ublock-origin.nix
    ./bitwarden.nix
    ./sponsorblock.nix
    ./multi-account-containers.nix
    ./stylus.nix
    ./decentraleyes.nix
  ];

  programs.firefox.policies = {
    ExtensionSettings."*".installation_mode = "blocked";
    ExtensionUpdate = false;
  };
}
