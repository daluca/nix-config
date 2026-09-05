{
  flake.overlays.lazyssh = _final: prev: {
    lazyssh = prev.lazyssh.overrideAttrs {
      version = "0.3.0+595f730";

      src = prev.fetchFromGitHub {
        owner = "gonsalvesc";
        repo = "lazyssh";
        rev = "XDG-base-directory";
        hash = "sha256-nNy69fFkqr8oHk86XW9XLbuSpDloqJb4dDjHE7Mfn58=";
      };

      vendorHash = "sha256-OMlpqe7FJDqgppxt4t8lJ1KnXICOh6MXVXoKkYJ74Ks=";
    };
  };

  flake.homeManagerModules.lazyssh = { pkgs, ... }: {
    home.packages = with pkgs; [
      lazyssh
    ];

    home.persistence.home.directories = [
      ".config/lazyssh"
      ".local/state/lazyssh"
    ];
  };
}
