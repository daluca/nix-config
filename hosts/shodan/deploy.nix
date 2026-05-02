{ deploy-rs, nixosConfigurations, secrets }:

{
  hostname = secrets.hosts.shodan.tailscale-address;
  sshUser = "root";
  profiles.system = {
    user = "root";
    path = deploy-rs.lib."x86_64-linux".activate.nixos nixosConfigurations.shodan;
  };
}
