{
  flake.homeManagerModules.proton-vpn = { pkgs, ... }: {
    home.packages = with pkgs; [
      proton-vpn
    ];
  };
}
