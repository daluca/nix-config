{ lib, inputs, ... }:
let
  inherit (lib) mkDefault mkImageMediaOverride;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"

    ../../nixos/openssh/server
    ../../users/root
  ];

  services.openssh.settings = {
    AllowUsers = mkImageMediaOverride null;
    PermitRootLogin = mkImageMediaOverride "yes";
  };

  system.stateVersion = mkDefault "24.11";
}
