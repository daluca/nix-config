{ lib, ... }:
let
  networks = {
    hetzner = {
      name = "Hetzner";
      description = "VPS servers on Hetzner";
      id = "dbsbq0ro9jd2dm7fk18g";
    };
    digitalocean = {
      name = "DigitalOcean";
      description = "VPS servers on DigitalOcean";
      id = "dbsbu8ro9jd2dm7fk5p0";
    };
    the_netherlands = {
      name = "The Netherlands";
      description = "Home residence";
      id = "dbsbu8ro9jd2dm7fk5n0";
    };
    united_kingdom = {
      name = "United Kingdom";
      description = "Brother's residence";
      id = "dbsbu8ro9jd2dm7fk5o0";
    };
    new_zealand = {
      name = "New Zealand";
      description = "Parent's residence";
      id = "dbsbu8ro9jd2dm7fk5ng";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "netbird_network.${name}";
  }) networks;

  resource.netbird_network = lib.mapAttrs (name: data: {
    inherit (data) name description;
  }) networks;
}
