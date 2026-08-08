{ self, ... }:

{
  flake.homeManagerModules.tools = { pkgs, ... }: {
    imports = with self.homeManagerModules; [
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
