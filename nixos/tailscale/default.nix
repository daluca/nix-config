{
  imports = [
    ./client
  ];

  networking.firewall.trustedInterfaces = [ "tailscaled0" ];
}
