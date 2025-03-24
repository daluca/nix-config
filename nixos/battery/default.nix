{ pkgs, ... }:

{
  systemd.services."battery-threshold" = {
    description = "Set battery charging threshold";
    after = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];

    script = /* bash */ ''
      ${pkgs.coreutils}/bin/echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    serviceConfig = {
      Type = "oneshot";
    };

    wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
  };
}
