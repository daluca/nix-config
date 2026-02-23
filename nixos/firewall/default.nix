{
  imports = [
    ./rules
  ];

  networking = {
    firewall.enable = true;
    nftables.enable = true;
  };
}
