{ lib, ... }:
let
  groups = {
    jellyfin.id = "1bf9ed03-201f-4933-b6b0-9130943e7e16";
    jellyfin_administrator.id = "ae56ae18-9989-4988-9927-8efb41f76e5d";
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
