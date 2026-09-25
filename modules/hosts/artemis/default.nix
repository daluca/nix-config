{ self, inputs, ... }:

{
  flake.nixosConfigurations.artemis =
    let
      secrets = fromTOML (builtins.readFile ../../../secrets/secrets.toml);
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit secrets; };
      modules = with self.nixosModules; [
        artemis
      ];
    };

  flake.nixosModules.artemis = { lib, ... }: {
    imports =
      with inputs;
      with self.nixosModules;
      [
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
        artemis-hardware-configuration
        laptop
        keychron
        pipewire
        plymouth
        grub
        gnome
        impermanence
        fonts
        fwupd
        steam
        distributed-builds
        yubikey
        tailscale
        firewall
        auto-cpufreq
        thinkfan
        scanners
        docker
      ];

    home-manager.users.daluca.imports = with self.homeModules; [
      artemis
    ];

    swapDevices =
      let
        GiB = 1024;
      in
      [
        {
          device = "/var/lib/swap/swapfile";
          size = 16 * GiB;
        }
      ];

    boot.initrd.luks.devices.cryptroot.allowDiscards = true;

    sops.defaultSopsFile = ./artemis.sops.yaml;

    deploy.tags = [
      "the-netherlands"
    ];

    networking.hostName = "artemis";

    time.timeZone = "Europe/Amsterdam";

    host.battery = true;

    host.network.interface = "wlp0s20f3";

    networking.localCommands = /* bash */ ''
      ip rule add to 10.1.0.0/16 priority 2500 lookup main || true
    '';

    boot.initrd.luks.devices.cryptroot.crypttabExtraOpts = [
      "tpm2-device=auto"
      "token-timeout=5s"
    ];

    boot.initrd.systemd.services.impermanence.script = lib.mkForce /* bash */ ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    boot.loader.grub.useOSProber = lib.mkForce true;

    system.stateVersion = "26.05";
  };

  flake.nixosModules.artemis-hardware-configuration =
    {
      config,
      lib,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/root_vg/root";
        fsType = "btrfs";
        options = [
          "subvol=root"
          "compress=zstd"
          "noatime"
        ];
      };

      boot.initrd.luks.devices.cryptroot.device =
        "/dev/disk/by-uuid/bad25602-f5e7-46c7-a0ec-6a1690ed5337";

      fileSystems."/nix" = {
        device = "/dev/root_vg/root";
        fsType = "btrfs";
        options = [
          "subvol=nix"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/persistent" = {
        device = "/dev/root_vg/root";
        fsType = "btrfs";
        options = [
          "subvol=persistent"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/var/lib/swap" = {
        device = "/dev/root_vg/root";
        fsType = "btrfs";
        options = [
          "subvol=swap"
          "defaults"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/AAA4-90DA";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

  flake.homeModules.artemis =
    {
      config,
      lib,
      pkgs,
      secrets,
      ...
    }:
    {
      imports = with self.homeModules; [
        nix-utils
        bitwarden
        development
        discord
        doctl
        faugusLauncher
        feishin
        anki
        firefox
        zenBrowser
        ghostty
        git
        gnupg
        heliumBrowser
        heroic
        intiface-central
        itch
        jujutsu
        kubernetes
        neovim
        lazygit
        lazyssh
        libreoffice
        mpv
        nextcloud
        proton-vpn
        thunderbird
        qrrs
        signal
        vscodium
        yazi
      ];

      programs.custom-firefox.default = "zen-browser";

      programs.tmux.extraConfig = /* tmux */ ''
        bind C-j display-popup -d "#{pane_current_path}" -w 90% -h 90% -E ${lib.getExe config.programs.jjui.package}
        bind C-t display-popup -d "#{pane_current_path}" -w 60% -h 60% -E ${lib.getExe config.programs.zsh.package}
        bind C-s display-popup -w 90% -h 90% -E ${lib.getExe pkgs.lazyssh}
      '';

      nix.registry = {
        neovim.to = {
          path = "${config.home.homeDirectory}/code/github.com/daluca/nixvim-config";
          type = "path";
        };
      };

      xdg.mimeApps.enable = true;

      services.ntfyd = {
        token = secrets.ntfy.token;
        topics = [
          "hosts"
          "gatus"
        ];
      };

      sops.age.keyFile = lib.mkOverride 10 ("/persistent" + "${config.xdg.configHome}/sops/age/keys.txt");

      sops.secrets."gsconnect/private.pem".sopsFile = ./artemis.sops.yaml;

      xdg.configFile."gsconnect/certificate.pem".source = ./certificate.pem;

      programs.zsh.sessionVariables = {
        ZSH_TMUX_DEFAULT_SESSION_NAME = "artemis";
      };
    };
}
