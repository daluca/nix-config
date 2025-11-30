{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkIf;
  cfg = config.programs.garden-tools;
in with lib; {
  options.programs.garden-tools = {
    enable = mkEnableOption "Garden grows and cultivates collections of Git trees";

    package = mkPackageOption pkgs "garden-tools" { };

    settings = lib.mkOption {
      type = types.attrs;
      default = { };
      description = "garden-tools global config file";
    };

    enableBashIntegration = mkEnableOption "Bash Integration" // {
      default = true;
    };

    enableZshIntegration = mkEnableOption "Zsh Integration" // {
      default = true;
    };

    enableFishIntegration = mkEnableOption "Fish Integration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."garden/garden.yaml" = lib.mkIf (cfg.settings != { }) {
      source = (pkgs.formats.yaml { }).generate "garden.yaml" cfg.settings;
    };

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        eval "$(${cfg.package}/bin/garden completion bash)"
      fi
    '';

    programs.zsh.initContent = mkIf cfg.enableZshIntegration ''
      if [[ $options[zle] = on ]]; then
        eval "$(${cfg.package}/bin/garden completion zsh)"
      fi
    '';

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
      ${cfg.package}/bin/garden completion fish | source
    '';
  };
}
