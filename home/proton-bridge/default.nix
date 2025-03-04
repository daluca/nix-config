{
  programs.proton-bridge = {
    enable = true;
  };

  home.persistence.home.directories = [
    ".config/protonmail/bridge-v3"
    ".local/share/protonmail/bridge-v3"
  ];
}
