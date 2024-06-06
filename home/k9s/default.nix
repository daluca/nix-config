{ config, pkgs, ... }:

{
  programs.k9s = {
    enable = true;
    package = pkgs.unstable.k9s;
    settings.k9s = {
      ui = {
        enableMouse = false;
        logoless = true;
        skin = "catppuccin-mocha";
      };
      skipLatestRevCheck = true;
    };
  };

  xdg.configFile."k9s/skins".source =
    pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "k9s";
      rev = "e08b9302aee2b7193d6fcc3a9ffd2f24d2957dbf";
      hash = "sha256-tg+xFNj9wkWFcD9bXDor/VCZVosoAH+8grz5FY5QgnM=";
    }
    + "/dist/";
}
