{ lib, ... }:
let
  secrets = fromTOML (builtins.readFile ../../secrets/secrets.toml);
  clients = {
    jellyfin = {
      launch_url = "https://jellyfin.${secrets.domains.general}/";
      callback_urls = [
        "https://jellyfin.${secrets.domains.general}/sso/OID/redirect/pocket-id"
      ];
      logout_callback_urls = [
        "https://jellyfin.${secrets.domains.general}/"
      ];
      allowed_user_groups = [
        (lib.tf.ref "pocketid_group.jellyfin.id")
        (lib.tf.ref "pocketid_group.jellyfin_administrator.id")
      ];
      id = "dd711786-3745-4199-bb0e-a7a2fff38407";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "pocketid_client.${name}";
  }) clients;

  resource.pocketid_client = lib.mapAttrs (name: data: {
    inherit (data)
      launch_url
      callback_urls
      logout_callback_urls
      allowed_user_groups
      ;
    name = lib.toSentenceCase name;
    pkce_enabled = true;
  }) clients;

  output =
    (lib.mapAttrs' (
      name: _data:
      lib.nameValuePair (name + "_client_id") {
        value = lib.tf.ref "pocketid_client.${name}.id";
        description = "Pocket ID OIDC client ID for ${lib.toSentenceCase name}";
      }
    ) clients)
    // (lib.mapAttrs' (
      name: _data:
      lib.nameValuePair (name + "_client_secret") {
        value = lib.tf.ref "pocketid_client.${name}.client_secret";
        description = "Pocket ID OIDC client secret for ${lib.toSentenceCase name}";
        sensitive = true;
      }
    ) clients);
}
