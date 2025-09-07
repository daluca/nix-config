{
  nix.buildMachines = [
    {
      hostName = "alfa";
      system = "x86_64-linux";
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      sshUser = "remotebuild";
      sshKey = "/etc/ssh/ssh_host_ed25519_key";
      protocol = "ssh-ng";
      maxJobs = 2;
      speedFactor = 2;
    }
  ];
}
