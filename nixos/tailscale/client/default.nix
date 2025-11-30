{
  imports = [
    ./..
  ];

  services.tailscale = {
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--shields-up"
      "--exit-node="
      "--exit-node-allow-lan-access"
    ];
  };
}
