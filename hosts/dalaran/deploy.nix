{ deploy-rs, nixosConfigurations }:

{
  hostname = "dalaran";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."aarch64-linux".activate.nixos nixosConfigurations.dalaran;
  };
}
