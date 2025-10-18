{ config, ... }:

{
  services.home-assistant = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      gtts # Google Translate
      aiontfy # ntfy.sh
    ];
    config = {
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" ];
      };
      homeassistant = {
        name = "Waalsdorperweg";
        unit_system = "metric";
        time_zone = "Europe/Amsterdam";
      };
      default_config = { };
    };
  };

  services.matter-server.enable = true;

  # networking.firewall.allowedTCPPorts = [
  #   config.services.matter-server.port
  # ];
}
