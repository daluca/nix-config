{ lib, pkgs, inputs, outputs, ... }:
let
  inherit (lib) mkDefault;
  inherit (pkgs) vim just;
  inherit (pkgs.unstable) disko;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  environment.systemPackages = [
    vim
    disko
    just
    ( pkgs.writeShellScriptBin "nix-config.sh" /* bash */ ''
      echo "Downloading daluca/nix-config"
      ${pkgs.git}/bin/git clone https://github.com/daluca/nix-config.git "''\${1:-nix-config}"
    '')
  ];

  system.stateVersion = mkDefault "24.11";
}
