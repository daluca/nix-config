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
    ];
  };
}
