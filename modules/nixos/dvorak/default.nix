{ config, ...}:

{
  services.xserver.xkb = {
    layout = "us,us";
    variant = "dvorak,";
  };
}