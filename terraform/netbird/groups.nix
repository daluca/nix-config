{ lib, ... }:
let
  groups = {
    administrators = {
      name = "Administrators";
      id = "dbscg93o9jd08gbf7290";
    };
    hetzner = {
      name = "Hetzner";
      id = "dbsd2aro9jd08gbf7p30";
    };
    servers = {
      name = "Servers";
      id = "dbsct9bo9jd08gbf7ib0";
    };
    the_netherlands = {
      name = "The Netherlands";
      id = "dbsq2ojo9jd08gbfh560";
    };
    united_kingdom = {
      name = "United Kingdom";
      id = "dbsq2ojo9jd08gbfh580";
    };
    new_zealand = {
      name = "New Zealand";
      id = "dbsq2ojo9jd08gbfh570";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "netbird_group.${name}";
  }) groups;

  resource.netbird_group = lib.mapAttrs (_name: data: {
    inherit (data) name;
  }) groups;

  data.netbird_group.all.name = "All";
}
