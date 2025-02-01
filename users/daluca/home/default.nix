{ osConfig, ... }:
let
  inherit (osConfig.networking) hostName;
in {
  imports = [
    (./. + "/${hostName}.nix")
  ];

  home = rec {
    username = "daluca";
    homeDirectory = "/home/${username}";
  };

  themes.catppuccin.flavour = "Mocha";
}
