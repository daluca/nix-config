{ secrets, outputs, ... }:

{
  imports = [
    ../dvorak
    ../home-manager
    ../secrets
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 28d";
  };

  # TODO: check what nix-ld actually does
  #
  # programs.nix-ld = {
  #   enable = false;
  #   package = pkgs.nix-ld-rs;
  # };

  time.timeZone = secrets.user.timezone;

  hardware.pulseaudio.enable = true;
  sound.enable = true;
}
