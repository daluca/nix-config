{ ... }:

{
  services.thinkfan = {
    enable = true;
  };

  boot.initrd.availableKernelModules = [ "thinkpad_acpi" ];
}
