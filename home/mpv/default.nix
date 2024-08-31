{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    package = pkgs.unstable.mpv;
    config = {
      ytdl-format = "bestvideo+bestaudio";
    };
  };

  programs.yt-dlp = {
    enable = true;
    package = pkgs.unstable.yt-dlp;
  };
}
