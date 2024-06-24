{
  config,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./gnome
    ./fonts
    ./gnupg
    ./dvorak
    ./networking
    ./docker
    ./tailscale
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "Pacific/Auckland";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [ git ];
}
