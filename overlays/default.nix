{ lib, inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: _prev: {
    kubectlPlugins = {
      view-secret = final.pkgs.view-secret;
      ingress-nginx = final.pkgs.ingress-nginx;
    };

    uutils-coreutils-done = (inputs.nixpkgs-unstable.legacyPackages.${final.system}.uutils-coreutils.override {
      prefix = "";
      buildMulticallBinary = false;
    }).overrideAttrs (oldAttrs: {
      preBuild = /* bash */ ''
        makeFlagsArray+=(SKIP_UTILS="${lib.concatStringsSep " " [
          "cat"
          "chmod"
          "cp"
          "csplit"
          "date"
          "dd"
          "du"
          "expr"
          "fmt"
          "head"
          "install"
          "ls"
          "misc"
          "mkdir"
          "mkfifo"
          "mv"
          "od"
          "pr"
          "printf"
          "ptx"
          "rm"
          "shred"
          "sort"
          "stty"
          "tac"
          "tail"
          "timeout"
          "tty"
        ]}")
      '';

      versionCheckProgram = "${placeholder "out"}/bin/arch";
    });
  };

  proton-ge = import ./proton-ge;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "plexmediaserver"
        "slack"
      ];
    };
  };
}
