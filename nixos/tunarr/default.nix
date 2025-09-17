let
  days = 24;
in {
  services.tunarr = {
    enable = true;
    port = 8108;
    settings = {
      settings.xmltv.programmingHours = 7 * days;
    };
  };
}
