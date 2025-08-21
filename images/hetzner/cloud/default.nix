{ lib, ... }:

{
  imports = [
    ./..
  ];

  boot.growPartition = lib.mkImageMediaOverride false;

  services.cloud-init.enable = false;
}
