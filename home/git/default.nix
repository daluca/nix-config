{ config, lib, pkgs, secrets, ... }:
let
  inherit (lib) mkIf;
  inherit (config.programs) zsh gpg;
  inherit (pkgs) sops git-agecrypt;
  inherit (secrets) user;
in {
  programs.git = {
    enable = true;
    userName = "Lucas Slebos";
    userEmail = user.email;
    signing = {
      key = "C4C6EC5DC2F369D7CCF8EE1D7626A2AB23757525";
      signByDefault = true;
      gpgPath = "${gpg.package}/bin/gpg";
    };
    ignores = [
      "/.vscode/"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rerere.enabled = true;
      url."git@github.com".insteadof = "github";
      diff."sopsdiffer".textconv = "${sops}/bin/sops decrypt";
      diff."git-agecrypt".textconv = "${git-agecrypt}/bin/git-agecrypt textconv";
      filter."git-agecrypt" = {
        required = true;
        smudge = "${git-agecrypt}/bin/git-agecrypt smudge -f %f";
        clean = "${git-agecrypt}/bin/git-agecrypt clean -f %f";
      };
    };
  };

  programs.zsh.oh-my-zsh.plugins = mkIf ( zsh.enable && zsh.oh-my-zsh.enable ) [
    "git"
  ];
}
