{ inputs, ... }:

{
  flake.nixosModules.nix-monitored = {
    imports = with inputs; [
      nix-monitored.nixosModules.default
    ];

    nix.monitored = {
      enable = true;
      notify = false;
    };
  };
}
