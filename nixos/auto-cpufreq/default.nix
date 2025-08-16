{ lib, ... }:

{
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        enable_thresholds = true;
        start_threshold = 20;
        stop_threshold = 80;
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  services.power-profiles-daemon.enable = lib.mkForce false;

  services.tlp.enable = lib.mkForce false;
}
