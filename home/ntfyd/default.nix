{ secrets, ... }:

{
  services.ntfyd = {
    enable = true;
    server = "ntfy.${secrets.cloud.domain}";
  };
}
