{ self, ... }:

{
  flake.homeModules.modernUnix = { pkgs, ... }: {
    imports = with self.homeModules; [
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
