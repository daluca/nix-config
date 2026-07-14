{
  hardware.logitech.wireless = {
    enable = true;
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Disable high resolution scrolling]
    MatchUdevType=mouse
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';
}
