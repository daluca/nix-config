{ pkgs, ... }:
let
  inherit (pkgs.unstable) bash-language-server;
in {
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      bashls.enable = true;
      bashls.package = bash-language-server;
      helm_ls.enable = true;
      lua_ls.enable = true;
      nixd.enable = true;
    };
  };
}
