{ deploy-rs, nixosConfigurations }:

{
  hostname = "azeroth";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."aarch64-linux".activate.nixos nixosConfigurations.stormwind;
  };
}
