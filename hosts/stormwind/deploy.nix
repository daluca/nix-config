{ deploy-rs, nixosConfigurations }:

{
  hostname = "stormwind";
  interactiveSudo = true;
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."aarch64-linux".activate.nixos nixosConfigurations.stormwind;
  };
}
