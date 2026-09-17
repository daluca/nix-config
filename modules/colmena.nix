{
  self,
  inputs,
  withSystem,
  ...
}:
let
  validHosts = inputs.nixpkgs.lib.filterAttrs (
    hostname: _:
    hostname == "dalaran"
    || hostname == "benedick"
    || hostname == "alfa"
    || hostname == "bravo"
    || hostname == "charlie"
    || hostname == "shodan"
    || hostname == "stormwind"
  ) self.nixosConfigurations;
in
{
  flake.overlays.colmena =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        inherit (inputs'.colmena.packages) colmena;
      }
    );

  flake.colmenaHive = inputs.colmena.lib.makeHive (
    {
      meta = {
        nixpkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        nodeNixpkgs = builtins.mapAttrs (_: nixos: nixos.pkgs) validHosts // {
          dalaran = inputs.nixos-raspberrypi.inputs.nixpkgs.legacyPackages."aarch64-linux";
        };
        nodeSpecialArgs = builtins.mapAttrs (_: nixos: nixos._module.specialArgs) validHosts;
      };
    }
    // builtins.mapAttrs (hostname: nixos: {
      imports = nixos._module.args.modules;
      deployment = {
        tags = nixos.config.system.nixos.tags ++ nixos.config.deploy.tags;
        targetHost =
          if (nixos.config.deploy.ipv4-address != null) then nixos.config.deploy.ipv4-address else hostname;
        targetUser = "daluca";
        sshOptions = [
          "-F"
          "none"
        ];
      };
    }) validHosts
  );
}
