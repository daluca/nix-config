{ self, ... }:

{
  flake.nixosModules.desktop = {
    imports = with self.nixosModules; [
      base
      kanata
      localsend
    ];

    time.timeZone = "Europe/Amsterdam";

    nix.settings = {
      warn-dirty = false;
      trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
      substituters = [
        "https://nix-community.cachix.org?priority=50"
        "ssh-ng://remotebuild@dalaran?priority=100&ssh-key=/etc/ssh/ssh_host_ed25519_key"
        "ssh-ng://daluca@stormwind?priority=110&ssh-key=/home/daluca/.ssh/id_ed25519"
      ];
    };

    deploy.tags = [
      "desktop"
    ];

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    home-manager.users.daluca.imports = with self.homeModules; [
      desktop
    ];
  };

  flake.homeModules.desktop = {
    imports = with self.homeModules; [
      uutils
      alacritty
      gradia
      planify
      element
      whatsapp
      ntfyd
    ];

    xdg.mimeApps.enable = true;
  };
}
