{
  nix.buildMachines = [{
    hostName = "192.168.178.11";
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
}
