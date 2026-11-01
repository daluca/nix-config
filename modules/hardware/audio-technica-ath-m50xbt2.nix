{ self, ... }:

{
  flake.nixosModules.disable-bluetooth-headset = {
    services.pipewire.wireplumber.extraConfig."disable-headset-profile" = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
    };
  };

  # flake.nixosModules.bluetooth-battery-charge = {
  #   hardware.bluetooth.settings = {
  #     General.Experimental = true;
  #   };
  # };

  flake.nixosModules.devices-audioTechnicaATHM50xBT2 = {
    imports = with self.nixosModules; [
      # bluetooth-battery-charge
      disable-bluetooth-headset
    ];

    # services.pipewire.wireplumber.extraConfig."disable-headset-profile" = {
    #   "monitor.bluez.properties" = {
    #     "bluez5.roles" = [
    #       "a2dp_sink"
    #       "a2dp_source"
    #     ];
    #   };
    # };
  };
}
