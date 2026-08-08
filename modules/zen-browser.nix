{
  flake.homeManagerModules.zenBrowser = {
    programs.custom-firefox = {
      enable = true;
      forks = [ "zen-browser" ];
    };
  };
}
