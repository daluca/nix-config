{ deploy-rs, nixosConfigurations }:

{
  hostname = "ironforge";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."aarch64-linux".activate.nixos nixosConfigurations.ironforge;
  };
}
