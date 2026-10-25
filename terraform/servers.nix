{ lib, ... }:
let
  servers = {
    alfa = {
      image = "ubuntu-24.04";
      server_type = "cx23";
      ip = "10.2.1.1";
      id = 107087235;
    };
    bravo = {
      image = "ubuntu-24.04";
      server_type = "cax11";
      ip = "10.2.1.2";
      id = 107254256;
    };
    charlie = {
      image = "ubuntu-24.04";
      server_type = "cx33";
      ip = "10.2.1.3";
      id = 124035060;
    };
    delta = {
      image = "ubuntu-26.04";
      server_type = "cx23";
      ip = "10.2.1.4";
      id = 172234820;
    };
  };
  networks = lib.mapAttrs (_name: data: rec {
    inherit (data) ip;
    server_id = data.id;
    network_id = lib.tf.ref "hcloud_network.europe.id";
    id = "${toString data.id}-${network_id}";
  }) servers;
in
{
  import =
    lib.mapAttrsToList (name: data: {
      inherit (data) id;
      to = "hcloud_server.${name}";
    }) servers
    ++ lib.mapAttrsToList (name: data: {
      inherit (data) id;
      to = "hcloud_server_network.${name}";
    }) networks;

  resource.hcloud_server = lib.mkMerge [
    (lib.mapAttrs (name: data: {
      inherit name;
      inherit (data) image server_type;
      location = "nbg1";
      ssh_keys = [
        (lib.tf.ref "hcloud_ssh_key.id_ed25519.id")
        (lib.tf.ref "hcloud_ssh_key.id_rsa.id")
      ];
      firewall_ids = [
        (lib.tf.ref "hcloud_firewall.default.id")
        (lib.tf.ref "hcloud_firewall.http.id")
      ];
      lifecycle.ignore_changes = [
        "ssh_keys"
      ];
    }) servers)
    {
      charlie.firewall_ids = [
        (lib.tf.ref "hcloud_firewall.netbird.id")
      ];
    }
  ];

  resource.hcloud_server_network = lib.mapAttrs (_name: data: {
    inherit (data) server_id network_id ip;
  }) networks;
}
