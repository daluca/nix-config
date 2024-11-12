{ lib, inputs, ... }:
let
  inherit (lib) mkDefault mkImageMediaOverride;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/digital-ocean-image.nix"

    ../../nixos/openssh-server
  ];

  services.openssh.settings = {
    AllowUsers = mkImageMediaOverride null;
    PermitRootLogin = mkImageMediaOverride "yes";
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZuHaRedC+s+EbKgGj1ZBQ0tClxgfYt6XVd1grNUgjV daluca@artemis"
    ];
  };

  system.stateVersion = mkDefault "24.05";
}
