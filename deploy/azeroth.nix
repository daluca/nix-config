{ deploy-rs, nixosConfigurations }:

{
  hostname = "azeroth";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."x86_64-linux".activate.nixos nixosConfigurations.azeroth;
  };
}
