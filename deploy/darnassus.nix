{ deploy-rs, nixosConfigurations }:

{
  hostname = "darnassus";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."aarch64-linux".activate.nixos nixosConfigurations.darnassus;
  };
}
