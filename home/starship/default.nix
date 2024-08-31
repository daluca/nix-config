{ pkgs, ... }:
let
  flavour = "mocha";
in {
  programs.starship.enable = true;
  programs.starship.enableBashIntegration = false;

  xdg.configFile."starship.toml".text = ''
    palette = "catppuccin_${flavour}"
    ''
    + (builtins.readFile ./starship.toml)
    + (builtins.readFile ( pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "starship";
      rev = "ca2fb0600730fd3958a2cb4d4ca97c401877b365";
      hash = "sha256-KzXO4dqpufxTew064ZLp3zKIXBwbF8Bi+I0Xa63j/lI=";
    } + "/palettes/${flavour}.toml"));
}
