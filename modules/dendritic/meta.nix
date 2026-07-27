{
  lib,
  flake-parts-lib,
  moduleLocation,
  ...
}:

with lib;
{
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      homeManagerModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (
          k: v: {
            _file = "${toString moduleLocation}#homeManagerModules.${k}";
            imports = [ v ];
          }
        );
        description = ''
          Home Manager modules.

          You may use this for reusable pieces of configuration, service modules, etc.
        '';
      };
    };
  };
}
