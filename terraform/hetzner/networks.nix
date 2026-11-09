{ lib, ... }:

{
  import = [
    {
      to = "hcloud_network.europe";
      id = 12051995;
    }
    {
      to = "hcloud_network_subnet.europe";
      id = "12051995-10.2.1.0/24";
    }
  ];

  resource.hcloud_network.europe = {
    name = "europe";
    ip_range = "10.2.0.0/16";
  };

  resource.hcloud_network_subnet.europe = {
    network_id = lib.tf.ref "hcloud_network.europe.id";
    type = "cloud";
    network_zone = "eu-central";
    ip_range = "10.2.1.0/24";
  };
}
