{ self, ... }:

{
  flake.homeManagerModules.modernUnix = { pkgs, ... }: {
    imports = with self.homeManagerModules; [
      bat
      eza
      fd
      ripgrep
    ];

    home.packages = with pkgs; [
      unstable.duf
      unstable.dust
      unstable.mprocs
      unstable.procs
      unstable.xh
    ];
  };
}
