{ config, pkgs, inputs, ... }:

{
  imports = with inputs; [
    (openthread-border-router + "/nixos/modules/services/home-automation/openthread-border-router.nix")
    ./integrations
  ];

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    config = {
      homeassistant = {
        name = "Waalsdorperweg";
        unit_system = "metric";
        time_zone = "Europe/Amsterdam";
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
        ];
      };
      mobile_app = { };
    };
    extraComponents = [
      "matter"
      "otbr"
      "thread"
      "isal"
    ];
    extraPackages = python3Packages: with python3Packages; [
      androidtvremote2
      pychromecast
    ];
  };

  services.matter-server.enable = true;

  services.openthread-border-router = {
    enable = true;
    package = pkgs.openthread-border-router;
    backboneInterface = "end0";
    radio = {
      device = "/dev/serial/by-id/usb-Nabu_Casa_Home_Assistant_Connect_ZBT-1_3a9311746212f01186e40514773d9da9-if00-port0";
      baudRate = 460800;
      flowControl = true;
    };
    web = {
      enable = true;
      listenAddress = "::";
    };
  };

  networking.firewall.allowedTCPPorts = with config.services; [
    openthread-border-router.web.listenPort
  ];
}
