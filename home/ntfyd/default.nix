{ secrets, ... }:

{
  services.ntfyd = {
    enable = true;
    server = "ntfy.${secrets.domain.general}";
  };
}
