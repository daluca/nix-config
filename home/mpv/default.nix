{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    config = {
      ytdl-format = "bestvideo+bestaudio";
    };
  };

  programs.yt-dlp = {
    enable = true;
    package = pkgs.unstable.yt-dlp;
  };

  xdg.mimeApps.defaultApplicationPackages = [
    config.programs.mpv.package
  ];
}
