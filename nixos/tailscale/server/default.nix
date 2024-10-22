{
  imports = [
    ../common.nix
  ];

  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--advertise-exit-node"
      "--ssh"
    ];
  };
}
