{
  flake.overlays.redlib-unstable = final: prev: {
    redlib = prev.redlib.overrideAttrs (oldAttrs: rec {
      version = "0.40.0";

      src = oldAttrs.src.override {
        rev = "v${version}";
        hash = "sha256-qv7vIls9BwgwDQuKEQU72J10MpaMfcLvIGfzl628eNU=";
      };

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-XgHXqH4EF8TEOI+cKJ0Z2j6QYRCwGgv8bmY8gZpPN9c=";
      };

      dontUseCmakeConfigure = true;

      nativeBuildInputs =
        with prev.pkgs;
        oldAttrs.nativeBuildInputs
        ++ [
          cmake
          perl
          git
          rustPlatform.bindgenHook
          pkg-config
        ];

      buildInputs = with prev.pkgs; [
        zstd
      ];

      checkFlags = oldAttrs.checkFlags ++ [
        "--skip=oauth::tests::test_generic_web_backend"
        "--skip=oauth::tests::test_mobile_spoof_backend"
      ];
    });

  };

  flake.nixosModules.redlib = { pkgs, ... }: {
    services.redlib = {
      enable = true;
      package = pkgs.unstable.redlib;
      address = "127.0.0.1";
      port = 18081;
      settings = {
        REDLIB_ENABLE_RSS = "on";
        REDLIB_ROBOTS_DISABLE_INDEXING = "on";
        REDLIB_DEFAULT_USE_HLS = "on";
        REDLIB_DEFAULT_SHOW_NSFW = "on";
        REDLIB_DEFAULT_FRONT_PAGE = "all";
      };
    };
  };
}
