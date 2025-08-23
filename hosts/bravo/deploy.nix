{ deploy-rs, nixosConfigurations }:

{
  hostname = "bravo";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."aarch64-linux".activate.nixos nixosConfigurations.bravo;
  };
}
