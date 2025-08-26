{ pkgs, secrets, osConfig, ... }:

{
  home.packages = with pkgs; [
    ntfy-sh
  ];

  home.sessionVariables = {
    NTFY_TOPIC="ntfy.${secrets.cloud.domain}/${osConfig.networking.hostName}";
  };
}
