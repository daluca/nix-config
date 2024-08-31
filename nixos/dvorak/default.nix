{ ... }:

{
  services.xserver.xkb = {
    layout = "us,us";
    variant = ",dvorak";
    options = "grp:win_space_toggle";
  };

  console.useXkbConfig = true;
}
