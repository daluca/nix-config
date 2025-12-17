{ pkgs, ... }:

{
  services.home-assistant = {
    extraComponents = [
      "matter"
      "thread"
      "otbr"
    ];
  };

  services.matter-server.enable = true;

  services.openthread-border-router = {
    enable = true;
    package = pkgs.openthread-border-router;
    radio = {
      baudRate = 460800;
      flowControl = true;
    };
    web.enable = true;
  };
}
