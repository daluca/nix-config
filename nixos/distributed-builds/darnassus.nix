{ config, ... }:
let
  inherit (config.networking) domain;
in {
  nix.buildMachines = [{
    hostName = "darnassus";
    system = "aarch64-linux";
    supportedFeatures = [
      "nixos-test"
      "benchmark"
      "big-parallel"
      "kvm"
      "gccarch-armv8-a"
    ];
    sshUser = "remotebuild";
    sshKey = "/etc/ssh/ssh_host_ed25519_key";
    protocol = "ssh-ng";
    maxJobs = 4;
  }];

  programs.ssh = {
    knownHosts = {
      darnassus = {
        hostNames = [ "darnassus" "darnassus.${domain}" ];
        publicKeyFile = ../../hosts/darnassus/keys/ssh_host_ed25519_key.pub;
      };
    };
  };
}
