{ config, lib, pkgs, secrets, ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Slebos";
    userEmail = secrets.user.email;
    signing = {
      key = "C4C6EC5DC2F369D7CCF8EE1D7626A2AB23757525";
      signByDefault = true;
      gpgPath = "${config.programs.gpg.package}/bin/gpg";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.zsh.oh-my-zsh.plugins = lib.mkIf ( config.programs.zsh.enable && config.programs.zsh.oh-my-zsh.enable ) [
    "git"
  ];
}
