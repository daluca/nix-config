{ self, ... }:

{
  flake.homeManagerModules.users-daluca-benedick = {
    imports = with self.homeManagerModules; [
      users-daluca

      development
      faugusLauncher
      ghostty
      git
      gnupg
      jujutsu
      mangohud
      neovim
      zenBrowser
      vscodium
    ];

    programs.custom-firefox.default = "zen-browser";
  };
}
