{ deploy-rs, nixosConfigurations }:

{
  hostname = "shodan";
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."x86_64-linux".activate.nixos nixosConfigurations.shodan;
  };
}
