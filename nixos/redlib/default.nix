{ pkgs, ... }:

{
  services.redlib = {
    enable = true;
    package = pkgs.unstable.redlib;
    address = "127.0.0.1";
    port = 18081;
    settings = {
      REDLIB_ENABLE_RSS = "on";
      REDLIB_ROBOTS_DISABLE_INDEXING = "on";
      REDLIB_DEFAULT_USE_HLS = "on";
      REDLIB_DEFAULT_SHOW_NSFW = "on";
      REDLIB_DEFAULT_FRONT_PAGE = "all";
    };
  };
}
