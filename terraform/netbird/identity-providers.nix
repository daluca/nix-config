{ lib, ... }:
let
  secrets = fromTOML (builtins.readFile ../../secrets/secrets.toml);
in
{
  import = [
    {
      id = "pocketid-dbsqo6bo9jd08gbfi74g";
      to = "netbird_identity_provider.pocketid";
    }
  ];

  resource.netbird_identity_provider.pocketid = {
    name = "Pocket ID";
    type = "pocketid";
    client_id = lib.tf.ref "pocketid_client.netbird.id";
    client_secret = lib.tf.ref "pocketid_client.netbird.client_secret";
    issuer = "https://id.${secrets.domains.general}";
  };
}
