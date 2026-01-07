{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    config = {
      ytdl-format = "bestvideo+bestaudio";
    };
  };

  xdg.mimeApps.defaultApplicationPackages = [
    config.programs.mpv.package
  ];
}
