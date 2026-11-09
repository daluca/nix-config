{ lib, ... }:
let
  group = name: lib.tf.ref "netbird_group.${name}.id";
  exit-nodes = {
    new_zealand = {
      enabled = true;
      description = "Exit node(s) to New Zealand";
      network_id = "New Zealand";
      groups = [
        (group "administrators")
      ];
      peer_groups = [
        (group "new_zealand")
      ];
      id = "dbsqaejo9jd08gbfhjt0";
    };
    the_netherlands = {
      enabled = true;
      description = "Exit node(s) to The Netherlands";
      network_id = "The Netherlands";
      groups = [
        (group "administrators")
      ];
      peer_groups = [
        (group "the_netherlands")
      ];
      id = "dbsqaejo9jd08gbfhjv0";
    };
    united_kingdom = {
      enabled = false;
      description = "Exit node(s) to The United Kingdom";
      network_id = "United Kingdom";
      groups = [
        (group "administrators")
      ];
      peer_groups = [
        (group "united_kingdom")
      ];
      id = "dbsqaejo9jd08gbfhju0";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "netbird_route.${name}";
  }) exit-nodes;

  resource.netbird_route = lib.mapAttrs (_name: data: {
    inherit (data)
      enabled
      description
      network_id
      peer_groups
      groups
      ;
    metric = 9999;
    network = "0.0.0.0/0";
    skip_auto_apply = true;
  }) exit-nodes;
}
