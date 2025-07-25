{ config, lib, pkgs, secrets, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Lucas Slebos";
        email = secrets.user.email;
      };
      ui = {
        default-command = "log";
        diff-editor = ":builtin";
      };
      signing = {
        behavior = "drop";
        key = "C4C6EC5DC2F369D7CCF8EE1D7626A2AB23757525";
        backend = "gpg";
        backends.gpg.programs = lib.getExe config.programs.gpg.package;
      };
      git = {
        auto-local-bookmark = true;
        signing-on-push = true;
        executable-path = lib.getExe config.programs.git.package;
      };
      "--scope" = [
        {
          "--when".commands = [ "status" ];
          ui.paginate = "never";
        }
        {
          "--when".commands = [ "diff" "show" ];
          ui = {
            pager = lib.getExe pkgs.delta;
            # TODO: Breacking change to update in NixOS 25.11
            # https://github.com/jj-vcs/jj/releases/tag/v0.30.0
            # diff-formatter = ":git"
            diff.format = "git";
          };
        }
      ];
    };
  };

  home.packages = with pkgs; [
    lazyjj
  ];
}
