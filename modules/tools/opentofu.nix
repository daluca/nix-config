{ self, ... }:

{
  flake.homeModules.opentofu = { pkgs, ... }: {
    imports = with self.homeModules; [
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
