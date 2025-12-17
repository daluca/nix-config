{ config, lib, ... }:

{
  services.home-assistant = {
    extraComponents = [
      "mqtt"
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant.enabled = config.services.home-assistant.enable;
      permit_join = true;
      frontend = {
        enable = true;
        host = "127.0.0.1";
        port = 8080;
        url = "http://127.0.0.1/";
      };
      serial = {
        adapter = "ember";
        baudrate = 115200;
        rtscts = true;
      };
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://127.0.0.1:1883";
        user = "zigbee2mqtt";
        password = "!secret password";
      };
    };
  };

  sops.templates."zigbee2mqtt/secrets.yaml" = with config.systemd.services; {
    path = "${config.services.zigbee2mqtt.dataDir}/secret.yaml";
    owner = zigbee2mqtt.serviceConfig.User;
    group = zigbee2mqtt.serviceConfig.Group;
    restartUnits = [ "zigbee2mqtt.service" ];
    content = lib.generators.toYAML { } {
      password = config.sops.placeholder."mqtt/zigbee2mqtt/password";
    };
  };

  services.mosquitto = { # spellchecker:disable-line
    enable = true;
    listeners = [
      {
        address = "127.0.0.1";
        acl = [
          "topic readwrite #"
        ];
        settings.allow_anonymous = false;
        users = {
          hass = { # spellchecker:disable-line
            acl = [
              "readwrite #"
            ];
            passwordFile = config.sops.secrets."mqtt/hass/password".path;
          };
          ${config.services.zigbee2mqtt.settings.mqtt.user} = {
            acl = [
              "readwrite #"
            ];
            passwordFile = config.sops.secrets."mqtt/zigbee2mqtt/password".path;
          };
        };
      }
    ];
  };

  sops.secrets."mqtt/hass/password" = {
    owner = "mosquitto"; # spellchecker:disable-line
    restartUnits = [ "mosquitto.service" ]; # spellchecker:disable-line
  };


  sops.secrets."mqtt/zigbee2mqtt/password" = {
    owner = "mosquitto"; # spellchecker:disable-line
    restartUnits = [ "mosquitto.service" ]; # spellchecker:disable-line
  };
}
