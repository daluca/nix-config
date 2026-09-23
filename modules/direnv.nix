{ self, ... }:

{
  flake.homeModules.direnv = { config, ... }: {
    imports = with self.homeModules; [
      vscodiumExtensions-direnv
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        strict_env = true;
        hide_env_diff = true;
        warn_timeout = "30s";
        whitelist.prefix = [
          "${config.home.homeDirectory}/Projects/github.com/daluca"
        ];
      };
    };

    programs.zsh.oh-my-zsh.plugins = [
      "direnv"
    ];
  };
}
