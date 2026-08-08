{ self, ... }:

{
  flake.homeManagerModules.just = { lib, pkgs, ... }: {
    imports = with self.homeManagerModules; [
      vscodiumExtensions-just
    ];

    home.packages = with pkgs; [
      unstable.just
    ];

    home.shellAliases = {
      j = "just";
    };

    home.sessionVariables = {
      JUST_COMMAND_COLOR = "blue";
    };

    programs.zsh.initContent = /* zsh */ ''
      if [[ -x "$( command -v just )" ]]; then
        eval "$(${lib.getExe pkgs.unstable.just} --completions zsh)"
      fi
    '';
  };
}
