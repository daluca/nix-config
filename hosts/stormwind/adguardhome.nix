{
  services.adguardhome.settings = {
    dns.bind_hosts = [ "10.0.0.10" ];
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
