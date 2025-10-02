{
  programs.proton-bridge = {
    enable = true;
  };

  sops.secrets."proton-bridge/password" = { };

  home.persistence.home.directories = [
    ".config/protonmail/bridge-v3"
    ".local/share/protonmail/bridge-v3"
  ];
}
