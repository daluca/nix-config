{ inputs, ... }:

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
      "isal"
    ];
    extraPackages = python3Packages: with python3Packages; [
      androidtvremote2
      pychromecast
    ];
  };
}
