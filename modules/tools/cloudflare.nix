{
  flake.homeModules.cloudflare = { lib, pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.cf
    ];

    programs.zsh.initContent = /* zsh */ ''
      eval "$( ${lib.getExe pkgs.unstable.cf} complete zsh )"
    '';

    home.persistence.home.directories = [
      ".config/cloudflare"
    ];
  };
}
