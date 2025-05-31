{ config, pkgs, secrets, ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Slebos";
    userEmail = secrets.user.email;
    signing = {
      key = "C4C6EC5DC2F369D7CCF8EE1D7626A2AB23757525";
      signByDefault = true;
      signer = "${config.programs.gpg.package}/bin/gpg";
    };
    ignores = [
      "/.vscode/"
    ];
    extraConfig = {
      core.compression = 9;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
      status.showStash = true;
      status.showUntrackedFiles = "all";
      rerere.enabled = true;
      url."git@github.com".insteadof = "github";
      url."git@gitlab.com".insteadof = "gitlab";
      url."ssh://git@codeberg.org".insteadof = "codeberg";
      diff."sopsdiffer".textconv = "${pkgs.sops}/bin/sops decrypt";
      diff."git-agecrypt".textconv = "${pkgs.git-agecrypt}/bin/git-agecrypt textconv";
      filter."git-agecrypt" = {
        required = true;
        smudge = "${pkgs.git-agecrypt}/bin/git-agecrypt smudge -f %f";
        clean = "${pkgs.git-agecrypt}/bin/git-agecrypt clean -f %f";
      };
    };
  };

  programs.zsh.oh-my-zsh.plugins = [
    "git"
  ];
}
