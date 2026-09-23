{ self, ... }:

{
  flake.homeModules.tools = { pkgs, ... }: {
    imports = with self.homeModules; [
      fzf
      gron
      zoxide
      delta
      jq
    ];

    home.packages = with pkgs; [
      yq-go
      curl
      file
      unzip
      dig
      tree
      entr
      toml-cli # TODO: Can likely be removed
    ];
  };
}
