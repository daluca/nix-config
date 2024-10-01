{ config, ... }:

{
  home.persistence.home.directories = [ "${config.xdg.configHome}/sops/age" ];
}
