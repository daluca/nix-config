{ self, ... }:

{
  flake.homeManagerModules.users-daluca-benedick = {
    imports = with self.homeManagerModules; [
      users-daluca

      # ../../../home/ghostty
      git
    ];
  };
}
