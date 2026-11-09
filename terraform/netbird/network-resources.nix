{ lib, ... }:
let
  network = name: lib.tf.ref "netbird_network.${name}.id";
  group = name: lib.tf.ref "netbird_group.${name}.id";
  network-resources = {
    trusted = {
      name = "Trusted network";
      description = "Full access to the Trusted subnet";
      address = "10.1.1.0/24";
      network_id = network "the_netherlands";
      groups = [
        (group "administrators")
      ];
      id = "dbscg93o9jd08gbf72ag";
    };
    iot = {
      name = "IoT network";
      description = "Full access to the IoT subnet";
      address = "10.1.10.0/24";
      network_id = network "the_netherlands";
      groups = [
        (group "administrators")
      ];
      id = "dbscj63o9jd08gbf76dg";
    };
    hetzner_cloud_europe = {
      name = "Hetzner cloud - Europe";
      description = "Full access to Hetzner Europe vpc";
      address = "10.2.1.0/24";
      network_id = network "hetzner";
      groups = [
        (group "administrators")
      ];
      id = "dbscv8jo9jd08gbf7ld0";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "netbird_network_resource.${name}";
  }) network-resources;

  resource.netbird_network_resource = lib.mapAttrs (name: data: {
    inherit (data)
      name
      description
      address
      network_id
      groups
      ;
  }) network-resources;
}
