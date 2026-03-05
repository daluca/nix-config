{
  imports = [
    ./..
  ];

  boot.kernelParams = [
    "ip=dhcp"
  ];
}
