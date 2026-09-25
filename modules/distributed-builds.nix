{ self, ... }:

{
  flake.nixosModules.distributed-builds = {
    imports = with self.nixosModules; [
      distributed-builds-dalaran
    ];

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;
  };

  flake.nixosModules.distributed-builds-nixbuild = {
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "eu.nixbuild.net";
          system = "aarch64-linux";
          maxJobs = 100;
          supportedFeatures = [
            "benchmark"
            "big-parallel"
          ];
        }
        {
          hostName = "eu.nixbuild.net";
          system = "x86_64-linux";
          maxJobs = 100;
          supportedFeatures = [
            "benchmark"
            "big-parallel"
          ];
        }
      ];
    };

    programs.ssh = {
      knownHosts = {
        nixbuild = {
          hostNames = [ "eu.nixbuild.net" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        };
      };
      extraConfig = /* ssh */ ''
        Host eu.nixbuild.net
          PubkeyAcceptedKeyTypes ssh-ed25519
          ServerAliveInterval 60
          IPQoS throughput
          IdentityFile /etc/ssh/ssh_host_ed25519_key
      '';
    };
  };

  flake.nixosModules.distributed-builds-alfa = { secrets, ... }: {
    nix.buildMachines = [
      {
        hostName = secrets.hosts.alfa.ipv4-address;
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
  };

  flake.nixosModules.distributed-builds-dalaran = {
    nix.buildMachines = [
      {
        hostName = "dalaran";
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
        speedFactor = 5;
      }
    ];
  };

  flake.nixosModules.distributed-builds-bravo = { secrets, ... }: {
    nix.buildMachines = [
      {
        hostName = secrets.hosts.bravo.ipv4-address;
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
  };

  flake.nixosModules.distributed-builds-darnassus = {
    nix.buildMachines = [
      {
        hostName = "192.168.1.212";
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
      }
    ];
  };

  flake.nixosModules.distributed-builds-guiltyspark = { secrets, ... }: {
    nix.buildMachines = [
      {
        hostName = secrets.hosts.guiltyspark.tailscale-address;
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
        maxJobs = 8;
      }
    ];
  };
}
