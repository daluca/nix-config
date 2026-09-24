{
  flake.homeModules.qrrs = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      qrrs
    ];

    programs.bash.initExtra = /* bash */ ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        eval "$(${lib.getExe pkgs.qrrs} --generate-completions bash)"
      fi
    '';

    programs.zsh.initContent = # zsh
      /* bash */ ''
        if [[ $options[zle] = on ]]; then
          eval "$(${lib.getExe pkgs.qrrs} --generate-completions zsh)"
        fi
      '';

    home.shellAliases = {
      qr = /* bash */ ''
        qrrs --margin 2
      '';
    };
  };
}
