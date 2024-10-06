{
  imports = [
    ../common.nix
  ];

  services.tailscale = {
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--shields-up"
    ];
  };
}
