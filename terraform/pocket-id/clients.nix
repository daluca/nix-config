{ lib, ... }:
let
  secrets = fromTOML (builtins.readFile ../../secrets/secrets.toml);
  group = name: lib.tf.ref "pocketid_group.${name}.id";
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
        (group "jellyfin")
        (group "jellyfin_administrator")
      ];
      id = "dd711786-3745-4199-bb0e-a7a2fff38407";
    };
    netbird = {
      launch_url = "https://netbird.${secrets.domains.general}/";
      callback_urls = [
        "https://netbird.${secrets.domains.general}/oauth2/callback"
      ];
      logout_callback_urls = [
        "https://netbird.${secrets.domains.general}/oauth2/logout/callback"
      ];
      allowed_user_groups = [
        (group "netbird")
      ];
      id = "7da8f30a-ddc3-4e4e-824b-abb16aa7cfc7";
    };
    seerr = {
      launch_url = "https://request.${secrets.domains.general}/";
      callback_urls = [
        "https://request.${secrets.domains.general}/login"
        "https://request.${secrets.domains.general}/profile/settings/linked-accounts"
      ];
      logout_callback_urls = [ ];
      allowed_user_groups = [
        (group "jellyfin")
      ];
      id = "8af61067-3122-4865-bb67-8f38927edf79";
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
