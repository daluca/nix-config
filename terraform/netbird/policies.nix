{ lib, ... }:
let
  group = name: lib.tf.ref "netbird_group.${name}.id";
  policies = {
    hetzner = {
      name = "Hetzner to Hetzner";
      description = "Allow connections between Hetzner nodes";
      rule = {
        name = "Hetzner to Hetzner";
        action = "accept";
        bidirectional = true;
        sources = [
          (group "hetzner")
        ];
        destinations = [
          (group "hetzner")
        ];
      };
      id = "dbsd2aro9jd08gbf7p4g";
    };
    servers = {
      name = "Administrators to Servers";
      description = "Grant Administrators access to servers";
      rule = {
        name = "Administrators to Servers";
        action = "accept";
        bidirectional = false;
        sources = [
          (group "administrators")
        ];
        destinations = [
          (group "servers")
        ];
      };
      id = "dbsd7fro9jd08gbf81jg";
    };
  };
in
{
  resource.netbird_policy = lib.mapAttrs (name: data: {
    inherit (data) name description rule;
  }) policies;
}
