{
  flake.nixosModules.sudo = { config, lib, ... }: {
    security.sudo.extraConfig = ''
      Defaults pwfeedback
    '' + lib.optionalString config.environment.persistence.system.enable ''
      Defaults lecture = never
    '';
  };
}
