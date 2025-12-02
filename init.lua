if not vim.g.vscode then
	require("lazy-nvim")

	require("core.options")
	require("core.keymaps")

	require("ui.nvim-tree")
	require("ui.lualine")
	require("ui.bufferline")

	require("util.telescope")
	require("util.treesitter")
	require("util.gitsigns")

	require("lsp.mason")
	require("lsp.lspsaga")
	require("lsp.lsp")
	require("lsp.formatter")
end
