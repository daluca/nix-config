{
  flake.homeManagerModules.nh = { config, pkgs, ... }: {
    programs.nh = {
      enable = true;
      package = pkgs.unstable.nh;
      flake = "${config.home.homeDirectory}/Projects/github.com/daluca/nix-config";
    };
  };
}
