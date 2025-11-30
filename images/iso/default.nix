{ lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  environment.systemPackages = with pkgs; [
    vim
    disko
    just
    ( pkgs.writeShellScriptBin "nix-config.sh" /* bash */ ''
      echo "Downloading daluca/nix-config"
      ${lib.getExe pkgs.git} clone https://github.com/daluca/nix-config.git "''\${1:-nix-config}"
    '')
  ];

  system.stateVersion = lib.mkDefault "25.11";
}
