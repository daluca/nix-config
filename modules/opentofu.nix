{ self, ... }:

{
  flake.homeManagerModules.opentofu = { pkgs, ... }: {
    imports = with self.homeManagerModules; [
      vscodiumExtensions-opentofu
    ];

    home.packages = with pkgs; [
      opentofu
    ];

    programs.zsh.oh-my-zsh.plugins = [
      "opentofu"
    ];

    home.shellAliases = {
      tf = "tofu";
    };
  };
}
