{
  imports = [
    ../.
  ];

  boot.initrd.kernelModules = [
    "ip=dhcp"
  ];
}
