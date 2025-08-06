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
      aliases = let
        command = exec: [ "util" "exec" "--" ] ++ lib.flatten [ exec ];
        bash = script: command [ "${pkgs.runtimeShell}" "-c" script "" ];
      in {
        pull = [ "git" "fetch" ];
        push = bash /* bash */ ''
          set -euo pipefail

          [ "$#" -ge 1 ] && REVSET="bookmarks($1)" || REVSET="@-"

          CHANGED_FILES="$( jj log --no-graph -r "mutable()::@- & fork_point(trunk())-::''${REVSET}" --name-only --no-pager -T "" )"
          [[ -z "''${CHANGED_FILES}" ]] && echo "No mutable files changed, no checks to run." || pre-commit run --file "''${CHANGED_FILES}"
          jj git push -r "''${1:-@-}"
        '';
        lazy = command (lib.getExe pkgs.lazyjj);
      };
      git = {
        auto-local-bookmark = true;
        sign-on-push = true;
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
