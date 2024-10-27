{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff".action = "find_files";
	      "<leader>fg".action = "live_grep";
	      "<leader>fk".action = "keymaps";
      };
    };
    web-devicons.enable = true;
  };

  programs.fd.enable = true;

  programs.ripgrep.enable = true;
}
