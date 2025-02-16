{ deploy-rs, nixosConfigurations }:

{
  hostname = "unifi";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."x86_64-linux".activate.nixos nixosConfigurations.unifi;
  };
}
