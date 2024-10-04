{ ... }:

{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
        { name = "zsh"; }
      ];

      mapping = {
        "<CR>" = /* lua */ ''
          cmp.mapping.confirm({ select = true })
        '';
        "<TAB>" = /* lua */ ''
          cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})
        '';
        "<S-TAB>" = /* lua */ ''
          cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})
        '';
      };
    };
  };
}
