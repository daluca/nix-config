{ config, ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Slebos";
    userEmail = "lucas@slebos.nz";
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgSign = true;
      tag.gpgSign = true;
      user.signingKey = "C4C6EC5DC2F369D7CCF8EE1D7626A2AB23757525";
      push.autoSetupRemote = true;
    };
  };

  imports = [ ../gnupg ];
}
