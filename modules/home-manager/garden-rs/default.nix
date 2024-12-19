{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkIf;
  cfg = config.programs.garden-rs;
in {
  options.programs.garden-rs = {
    enable = mkEnableOption "Garden grows and cultivates collections of Git trees";

    package = mkPackageOption pkgs "garden-rs" { };

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

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        eval "$(${cfg.package}/bin/garden completion bash)"
      fi
    '';

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
      if [[ $options[zle] = on ]]; then
        eval "$(${cfg.package}/bin/garden completion zsh)"
      fi
    '';

    programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
      ${cfg.package}/bin/garden completion fish | source
    '';
  };
}
