{ self, inputs, ... }:
let
  # NOTE: Remove once a better way to pass git-agecrypt secrets is found
  secrets = fromTOML (builtins.readFile ../secrets/secrets.toml);
  GiB = 1024 * 1024 * 1024;
in
{
  flake.nixosModules.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      imports =
        with inputs;
        with self.nixosModules;
        [
          inputs.impermanence.nixosModules.impermanence

          jellyplex-watched
          tunarr
          host
          attic-watch-store
          grub
          configarr

          sudo
          sops-nix
          home-manager
          dvorak
          networking
          users-root
          users-daluca
          ssh
          nixCache
          colmena
        ];

      system.nixos.tags = [
        (lib.removeSuffix "-linux" system)
      ];

      boot.extraModprobeConfig = ''
        install algif_aead /bin/false
      '';

      sops.secrets."ssh_host_ed25519_key" = { };

      sops.secrets."ssh_host_rsa_key" = { };

      sops.templates."netrc".content = ''
        machine attic.${secrets.domain.general}
        password ${config.sops.placeholder."attic/api-token"}
      '';

      sops.secrets."attic/api-token" = { };

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://nix-community.cachix.org?priority=50"
          "https://attic.${secrets.domain.general}/production?priority=60"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "production:fGtC1cQt7NrvIl7VD8nqnYsICCYK5CKQdxuZiYp+Q40="
        ];
        download-buffer-size = 1 * GiB;
        trusted-users = [ "@wheel" ];
        netrc-file = config.sops.templates."netrc".path;
      };

      nix.nixPath = [
        "nixpkgs=flake:nixpkgs"
      ]
      ++ lib.optional config.nix.channel.enable "/nix/var/nix/profiles/per-user/root/channels";

      nix.registry =
        lib.mapAttrs (_: value: { flake = lib.mkForce value; }) (lib.filterAttrs (n: _: n != "self") inputs)
        // {
          nix-config.flake = inputs.self;
          neovim.flake = inputs.nixvim-config;
        };

      nixpkgs.config.allowUnfree = true;

      nixpkgs.flake = {
        setNixPath = false;
        setFlakeRegistry = false;
      };

      nixpkgs.overlays =
        with inputs;
        builtins.attrValues self.overlays
        ++ [
          nur.overlays.default
          nix-vscode-extensions.overlays.default
          proton-ge.overlays.default
        ];

      nix.channel.enable = false;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        randomizedDelaySec = "45 minutes";
        options = "--delete-older-than 28d";
      };

      nix.optimise = {
        automatic = true;
        dates = [ "daily" ];
      };

      programs.nix-ld.enable = true;

      time.timeZone = lib.mkDefault "UTC";

      i18n = {
        defaultLocale = "en_NZ.UTF-8";
        extraLocales = map (locale: locale + ".UTF-8/UTF-8") [
          "C"
          "en_US"
          "en_GB"
          "en_AU"
          "nl_NL"
        ];
      };

      users.mutableUsers = false;

      environment.persistence.system.enable = lib.mkDefault false;

      environment.systemPackages = with pkgs; [
        vim
      ];
    };
}
