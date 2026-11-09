{ lib, ... }:
let
  setup-keys = {
    benedick = {
      auto_groups = [ ];
      id = "dbo8si3o9jd088bh80ug";
    };
    stormwind = {
      auto_groups = [ ];
      id = "dbo9p7jo9jd088bh8770";
    };
    dalaran = {
      auto_groups = [ ];
      id = "dboa2pjo9jd088bh8a50";
    };
    bravo = {
      auto_groups = [ ];
      id = "dbobcqjo9jd08an18jmg";
    };
    charlie = {
      auto_groups = [ ];
      id = "dboa4c3o9jd088bh8bvg";
    };
    delta = {
      auto_groups = [ ];
      id = "dboaiejo9jd088bh8ii0";
    };
    shodan = {
      auto_groups = [ ];
      id = "dbob7hjo9jd08an18du0";
    };
    guiltyspark = {
      auto_groups = [ ];
      id = "dboagr3o9jd088bh8hq0";
    };
    unifi = {
      auto_groups = [ ];
      id = "dbob8nbo9jd08an18eug";
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "netbird_setup_key.${name}";
  }) setup-keys;

  resource.netbird_setup_key = lib.mapAttrs (name: data: {
    inherit name;
    inherit (data) auto_groups;
    type = "reusable";
    expiry_seconds = 31557600; # 1 year
  }) setup-keys;

  output = lib.mapAttrs' (
    name: _data:
    lib.nameValuePair (name + "_setup_key") {
      value = lib.tf.ref "netbird_setup_key.${name}.key";
      description = "Netbird setup key for ${name}";
      sensitive = true;
    }
  ) setup-keys;
}
