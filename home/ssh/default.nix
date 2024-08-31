{ lib, osConfig, ... }:

{
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    matchBlocks = {
      gainas.hostname = "10.2.161.172";
    };
  };

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".ssh"
  ];
}
