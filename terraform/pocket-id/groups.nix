{ lib, ... }:
let
  groups = {
    jellyfin.id = "1bf9ed03-201f-4933-b6b0-9130943e7e16";
    jellyfin_administrator.id = "ae56ae18-9989-4988-9927-8efb41f76e5d";
    netbird.id = "f262d890-219d-4b20-9f74-433099a20bd9";
    family.id = "dc0a6f8c-42ec-4cc8-8991-65caa08a0ecf";
    friends.id = "2b102383-26a3-4d16-9a1b-1b9e1f76a552";
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "pocketid_group.${name}";
  }) groups;

  resource.pocketid_group = lib.mapAttrs (name: _data: {
    name = lib.replaceString "_" "-" name;
    friendly_name = lib.toSentenceCase (lib.replaceString "_" " " name);
  }) groups;
}
