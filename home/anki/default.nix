{ pkgs, ... }:

{
  programs.anki = {
    enable = true;
    addons = with pkgs.ankiAddons; [
      review-heatmap
      passfail2
      more-overview-stats
    ];
  };
}
