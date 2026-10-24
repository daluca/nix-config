{ lib, ... }:
let
  secrets = fromTOML (builtins.readFile ../secrets/secrets.toml);
  primary = {
    domain = secrets.domain.general;
    zone_id = "d05e5c424280a2487da182227416054a";
  };
  alfa = zone_id: {
    inherit zone_id;
    type = "A";
    content = secrets.hosts.alfa.ipv4-address;
  };
  bravo = zone_id: {
    inherit zone_id;
    type = "A";
    content = secrets.hosts.bravo.ipv4-address;
  };
  charlie = zone_id: {
    inherit zone_id;
    type = "A";
    content = secrets.hosts.charlie.ipv4-address;
  };
  shodan = zone_id: {
    inherit zone_id;
    type = "A";
    content = secrets.hosts.shodan.ipv4-address;
  };
  dns-records = {
    pocket_id = (charlie primary.zone_id) // {
      name = "id.${primary.domain}";
      id = "${primary.zone_id}/816a3413db17c2b31fe2d55f410ef491";
    };
    attic = (alfa primary.zone_id) // {
      name = "attic.${primary.domain}";
      id = "${primary.zone_id}/df6c5d6f80c31f24700f9e7eb222d131";
    };
    atuin = (bravo primary.zone_id) // {
      name = "atuin.${primary.domain}";
      id = "${primary.zone_id}/4be0b112a28b86094ad794a1a0769c1d";
    };
    hister = (charlie primary.zone_id) // {
      name = "hister.${primary.domain}";
      id = "${primary.zone_id}/10233ce3ff721cefac9f46f9298d3299";
    };
    jellyfin = (shodan primary.zone_id) // {
      name = "jellyfin.${primary.domain}";
      id = "${primary.zone_id}/71d03fc85d2c919e68057baf18eedef0";
    };
    miniflux = (bravo primary.zone_id) // {
      name = "miniflux.${primary.domain}";
      id = "${primary.zone_id}/520004ebe5ccc6e5b3f7d9fea45489f3";
    };
    netbird = (charlie primary.zone_id) // {
      name = "netbird.${primary.domain}";
      id = "${primary.zone_id}/70ef86c217cbe2255cca3eebdcb53dee";
    };
    nextflux = (bravo primary.zone_id) // {
      name = "nextflux.${primary.domain}";
      id = "${primary.zone_id}/c0299d9dd5c94ce2ff33d984faa29419";
    };
    ntfy = (bravo primary.zone_id) // {
      name = "ntfy.${primary.domain}";
      id = "${primary.zone_id}/954823c08c5dad5d416fe3c53b0ea3cf";
    };
    seerr = (shodan primary.zone_id) // {
      name = "request.${primary.domain}";
      id = "${primary.zone_id}/7bf40e6bd322ff3ea87bdf8041f4be6b";
    };
    rustfs = (charlie primary.zone_id) // {
      name = "rustfs.${primary.domain}";
      id = "${primary.zone_id}/119f8314234556bc1bbf6b24ad4cace7";
    };
    rustical = (charlie primary.zone_id) // {
      name = "rustical.${primary.domain}";
      id = "${primary.zone_id}/9752c9d09e162cf2b4eb1caf2e6b4714";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "cloudflare_dns_record.${name}";
  }) dns-records;

  resource.cloudflare_dns_record = lib.mkMerge [
    (lib.mapAttrs (_name: data: {
      inherit (data)
        name
        type
        content
        zone_id
        ;
      ttl = 1;
      proxied = true;
    }) dns-records)
    {
      netbird.proxied = lib.mkForce false;
    }
  ];
}
