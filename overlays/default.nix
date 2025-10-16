{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: _prev: with inputs; {
    fzf-preview = fzf-preview.packages.${final.system}.fzf-preview;

    kubectlPlugins = {
      view-secret = final.pkgs.view-secret;
      ingress-nginx = final.pkgs.ingress-nginx;
    };

    colmena = colmena.packages.${final.system}.colmena;

    neovim = nixvim-config.packages.${final.system}.neovim;
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
