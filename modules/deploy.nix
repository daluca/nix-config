{ self, inputs, ... }:

{
  flake.deploy.nodes = (
    builtins.mapAttrs (hostname: nixos: {
      inherit hostname;
      sshUser = "root";
      profiles.system = {
        user = "root";
        path =
          inputs.deploy-rs.lib.${nixos.pkgs.stdenv.hostPlatform.system}.activate.nixos
            self.nixosConfigurations.dalaran;
      };
    }) self.nixosConfigurations
  );
}
