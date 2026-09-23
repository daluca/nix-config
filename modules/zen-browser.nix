{
  flake.homeModules.zenBrowser = {
    programs.custom-firefox = {
      enable = true;
      forks = [ "zen-browser" ];
    };
  };
}
