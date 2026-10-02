{
  self,
  inputs,
  ...
}:
{
  flake.colmenaHive = inputs.colmena.lib.makeHive (
    {
      meta = {
        nixpkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        nodeNixpkgs = builtins.mapAttrs (_: nixos: nixos.pkgs) self.nixosConfigurations // {
          dalaran = inputs.nixos-raspberrypi.inputs.nixpkgs.legacyPackages."aarch64-linux";
        };
        nodeSpecialArgs = builtins.mapAttrs (_: nixos: nixos._module.specialArgs) self.nixosConfigurations;
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
    }) self.nixosConfigurations
  );
}
