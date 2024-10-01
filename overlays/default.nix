{ inputs, getName }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: { };

  proton-ge = import ./proton-ge;

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
      ];
    };
  };
}
