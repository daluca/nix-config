{
  self,
  inputs,
  withSystem,
  ...
}:

{
  perSystem = { system, ... }: {
    checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
  };

  flake.overlays.deploy-rs =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        inherit (inputs'.deploy-rs.packages) deploy-rs;
      }
    );

  flake.deploy.nodes = builtins.mapAttrs (hostname: nixos: {
    hostname =
      if (nixos.config.deploy.ipv4-address != null) then nixos.config.deploy.ipv4-address else hostname;
    groups = nixos.config.system.nixos.tags ++ nixos.config.deploy.tags;
    sshUser = "daluca";
    sshOpts = [
      "-F"
      "none"
    ];
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.${nixos.pkgs.stdenv.hostPlatform.system}.activate.nixos nixos;
    };
  }) self.nixosConfigurations;
}
