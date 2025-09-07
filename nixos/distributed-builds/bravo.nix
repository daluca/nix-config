{
  nix.buildMachines = [
    {
      hostName = "bravo";
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
      maxJobs = 2;
      speedFactor = 2;
    }
  ];

  nix.settings.substituters = [ "ssh-ng://remotebuild@bravo?ssh-key=/etc/ssh/ssh_host_ed25519_key" ];
}
