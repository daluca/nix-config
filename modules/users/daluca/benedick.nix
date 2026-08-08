{ self, ... }:

{
  flake.homeManagerModules.users-daluca-benedick = {
    imports = with self.homeManagerModules; [
      users-daluca

      ghostty
      git
      gnupg
    ];
  };
}
