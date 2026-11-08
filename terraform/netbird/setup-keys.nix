{ lib, ... }:
let
  setup-keys = {
    benedick.id = "dbo8si3o9jd088bh80ug";
    stormwind.id = "dbo9p7jo9jd088bh8770";
    dalaran.id = "dboa2pjo9jd088bh8a50";
    bravo.id = "dbobcqjo9jd08an18jmg";
    charlie.id = "dboa4c3o9jd088bh8bvg";
    delta.id = "dboaiejo9jd088bh8ii0";
    shodan.id = "dbob7hjo9jd08an18du0";
    guiltyspark.id = "dboagr3o9jd088bh8hq0";
    unifi.id = "dbob8nbo9jd08an18eug";
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    inherit (data) id;
    to = "netbird_setup_key.${name}";
  }) setup-keys;

  resource.netbird_setup_key = lib.mapAttrs (name: _data: {
    inherit name;
    type = "reusable";
    expiry_seconds = 31557600; # 1 year
  }) setup-keys;

  output = lib.mapAttrs' (
    name: _data:
    lib.nameValuePair (name + "_setup_key") {
      value = lib.tf.ref "netbird_setup_key.${name}.key";
      sensitive = true;
    }
  ) setup-keys;
}
