if not vim.g.vscode then
	require("lazy-nvim")

	require("ui.lualine")
	require("ui.bufferline")

	require("util.telescope")
	require("util.treesitter")
	require("util.gitsigns")

	require("lsp.mason")
	require("lsp.keymaps")
	require("lsp.lsp")

	require("core.options")
	require("core.keymaps")
end
