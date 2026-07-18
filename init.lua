if not vim.g.vscode then
	require("lazy-nvim")

	require("ui.lualine")
	require("ui.bufferline")

	require("util.telescope")
	require("util.gitsigns")

	require("lsp.mason")
	require("lsp.lspsaga")

	require("core.options")
	require("core.keymaps")
end
