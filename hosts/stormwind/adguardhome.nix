{ config, ... }:
let
  hostIPAddress = "10.0.0.10";
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ hostIPAddress ];
      upstream_dns = [
        "[/10.in-addr.arpa/]10.0.0.1"
        "[/internal/]10.0.0.1"
      ];
    };
    filtering = {
      rewrites = [{
        domain = "${config.networking.hostName}.internal";
        answer = hostIPAddress;
      }];
    };
    clients.persistent = [
      {
        name = "Work Laptop";
        ids = [ "10.0.0.40" ];
        tags = [
          "device_laptop"
          "os_windows"
        ];
        use_global_settings = false;
      }
      {
        name = "Work Phone";
        ids = [ "10.0.0.41" ];
        tags = [
          "device_phone"
          "os_android"
        ];
        use_global_settings = false;
      }
    ];
  };
}
