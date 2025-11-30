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
        default-command = [
          "log"
          "-r"
          "(trunk()..@):: | (trunk()..@)-"
        ];
        diff-editor = ":builtin";
      };
      signing = {
        behavior = "drop";
        key = "C4C6EC5DC2F369D7CCF8EE1D7626A2AB23757525";
        backend = "gpg";
        backends.gpg.programs = lib.getExe config.programs.gpg.package;
      };
      revset-aliases = {
        "closest_bookmark(revset)" = "heads(::revset & bookmarks())";
        "closest_pushable(revset)" = "heads(::revset & mutable() & ~description(exact:\"\") & (~empty() | merges()))";
      };
      aliases = let
        command = exec: [ "util" "exec" "--" ] ++ lib.flatten [ exec ];
        bash = script: command [ "${pkgs.runtimeShell}" "-c" script "" ];
      in {
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@)"
          "--to"
          "closest_pushable(@)"
        ];
        retrunk = [
          "rebase"
          "--revisions"
          "fork_point(@ | trunk())+::@ | @::"
          "--destination"
          "trunk()"
        ];
        pull = [ "git" "fetch" ];
        push = bash /* bash */ ''
          set -euo pipefail

          POSITIONAL_ARGS=()
          BOOKMARK=""

          while [[ "$#" -gt 0 ]]; do
            case "$1" in
              --bookmark|--revisions|-b|-r)
                BOOKMARK="$2"
                shift 2
                ;;
              --help|-h)
                jj git push --help
                exit 0
                ;;
              *)
                POSITIONAL_ARGS+=("$1")
                shift
                ;;
            esac
          done

          set -- "''${POSITIONAL_ARGS[@]}"

          REVSET="''${BOOKMARK:-@-}"

          CHANGED_FILES="$( jj log --no-graph -r "mutable()::@- & fork_point(trunk())-::''${REVSET}" --name-only --no-pager -T "" | sort -u )"
          readarray -t CHANGED_FILES <<< "''${CHANGED_FILES}"
          if [[ -z "''${CHANGED_FILES}" ]]; then
            echo "No mutable files changed, no checks to run."
          else
            pre-commit run --file "''${CHANGED_FILES[@]}"
          fi

          jj git push --revisions "''${REVSET}" "''${POSITIONAL_ARGS[@]}"
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
            diff-formatter = ":git";
          };
        }
      ];
    };
  };

  home.packages = with pkgs; [
    lazyjj
  ];
}
