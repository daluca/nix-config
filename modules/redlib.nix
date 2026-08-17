{
  flake.overlays.redlib = final: prev: {
    redlib = prev.redlib.overrideAttrs (oldAttrs: rec {
      version = "0.36.0-unstable-2026-04-24";

      src = oldAttrs.src.override {
        rev = "a4d36e954cf1bd64f209cd8868c5a29edc81b374";
        hash = "sha256-siyD6A12UALQIV7BMd7zu1TaojleTEYtpxPszuhx1/Y=";
      };

      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-eO3c7rlFna3DuO31etJ6S4c7NmcvgvIWZ1KVkNIuUqQ=";
      };

      nativeBuildInputs =
        with prev.pkgs;
        oldAttrs.nativeBuildInputs
        ++ [
          cmake
          go
          perl
          git
          rustPlatform.bindgenHook
        ];

      checkFlags = oldAttrs.checkFlags ++ [
        "--skip=oauth::tests::test_generic_web_backend"
        "--skip=oauth::tests::test_mobile_spoof_backend"
      ];
    });

  };

  flake.nixosModules.redlib = {
    services.redlib = {
      enable = true;
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
