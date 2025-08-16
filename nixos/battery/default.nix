{
  systemd.services."battery-threshold" = {
    description = "Set battery charging threshold";
    after = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];

    script = /* bash */ ''
      echo 21 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 81 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    serviceConfig.Type = "oneshot";

    wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
  };
}
