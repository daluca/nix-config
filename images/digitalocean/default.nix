{ inputs, ... }:

{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"

    ../../nixos/openssh/server
    ../../users/root
  ];

  system.stateVersion = "24.11";
}
