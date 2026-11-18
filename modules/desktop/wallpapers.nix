{ withSystem, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.wallpapers =
      let
        boston-usa = pkgs.fetchurl {
          url = "https://i.redd.it/ch72w5o76e591.png";
          hash = "sha256-v5G1AJkkhdBrLV4Tw30f3sdw0QqyG5HyypPOj24A/+w=";
          name = "boston-usa.png";
        };
        space-clouds = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/d8/wallhaven-d8386j.png";
          hash = "sha256-kjlrWCnKGLXxkkeu0QjVDHc/3HR79lMkqgRT1k9gbkk=";
          name = "space-clouds.png";
        };
        nier-2B = pkgs.fetchurl {
          url = "https://w.wallhaven.cc/full/j3/wallhaven-j3ww15.jpg";
          hash = "sha256-kwJ3lw/qLLbqqkngUY+BuI4+CcmZHs1dzDQ7RAq5Y5E=";
          name = "nier-2B.jpg";
        };
        lake-heron-nz = pkgs.fetchurl {
          url = "https://i.redd.it/jqv2fl23atxe1.png";
          hash = "sha256-Hk6ouW1CP+LPGCbr4ybz/QruPEd8PaGdz6ZcitPVYVY=";
          name = "lake-heron-nz.png";
        };
        patagonia = pkgs.fetchurl {
          url = "https://i.redd.it/y8veqygjt7xe1.png";
          hash = "sha256-vnyOWoalgJiCVYPlwrpsBqzQsE1wQ7GY3/nXQTaGGaA=";
          name = "patagonia.png";
        };
      in
      pkgs.stdenvNoCC.mkDerivation {
        pname = "wallpapers";
        version = "0.0.1";

        phases = [ "unpackPhase" ];

        unpackPhase = /* bash */ ''
          mkdir -p $out/share/wallpapers/
          cp ${boston-usa} $out/share/wallpapers/
          cp ${space-clouds} $out/share/wallpapers/
          cp ${nier-2B} $out/share/wallpapers/
          cp ${lake-heron-nz} $out/share/wallpapers/
          cp ${patagonia} $out/share/wallpapers/
        '';
      };
    };

  flake.overlays.wallpapers =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        inherit (self'.packages) wallpapers;
      }
    );
}
