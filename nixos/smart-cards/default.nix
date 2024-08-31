{ pkgs, ... }:

{
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
