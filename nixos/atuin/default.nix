{ config, pkgs, inputs, ... }:

{
  disabledModules = [
    "services/misc/atuin.nix"
  ];

  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/misc/atuin.nix")
  ];

  services.atuin = {
    enable = true;
    # TODO: Remove in 26.05
    package = pkgs.unstable.atuin;
    openRegistration = true;
  };

  environment.persistence.system.directories = with config.services; [
    {
      directory = dirOf postgresql.dataDir;
      user = "postgres";
      group = "postgres";
      mode = "0750";
    }
    {
      directory = postgresql.dataDir;
      user = "postgres";
      group = "postgres";
      mode = "0750";
    }
  ];
}
