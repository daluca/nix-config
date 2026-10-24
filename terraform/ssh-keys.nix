{ lib, ... }:
let
  ssh-keys = {
    id_ed25519 = {
      public_key = builtins.readFile ../modules/users/daluca/keys/id_ed25519.pub;
      id = "100601010";
    };
    id_rsa = {
      public_key = builtins.readFile ../modules/users/daluca/keys/id_rsa.pub;
      id = "130766621";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    to = "hcloud_ssh_key.${name}";
    inherit (data) id;
  }) ssh-keys;

  resource.hcloud_ssh_key = lib.mapAttrs (name: data: {
    inherit name;
    inherit (data) public_key;
  }) ssh-keys;
}
