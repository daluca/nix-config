{ pkgs, ... }:

{
  services.redlib = {
    enable = true;
    package = pkgs.unstable.redlib;
    address = "127.0.0.1";
    port = 18081;
    settings =
    let
      true = "on";
    in {
      REDLIB_ENABLE_RSS = true;
      REDLIB_ROBOTS_DISABLE_INDEXING = true;
      REDLIB_DEFAULT_USE_HLS = true;
      REDLIB_DEFAULT_SHOW_NSFW = true;
      REDLIB_DEFAULT_FRONT_PAGE = "all";
    };
  };
}
