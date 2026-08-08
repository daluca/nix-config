{
  flake.homeManagerModules.starship = { lib, ... }: {
    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      settings = {
        format = lib.concatStringsSep "" [
          "$directory"
          "$fill"
          "$all"
          "$line_break"
          "$character"
        ];
        right_format = lib.concatStringsSep "" [
          "$cmd_duration"
          "$time"
        ];
        add_newline = true;
        direnv.disabled = false;
        fill.symbol = " ";
        localip = {
          disabled = false;
          ssh_only = true;
        };
        nix_shell = {
          disabled = false;
          symbol = " ";
        };
        os = {
          disabled = false;
          symbols = {
            NixOS = " ";
          };
        };
        shell.disabled = false;
        sudo.disabled = false;
        time.disabled = false;
      };
    };

    catppuccin.starship.enable = true;
  };
}
