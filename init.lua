if not vim.g.vscode then
	require("lazy-nvim")

	-- 基础配置（必须在 UI 插件之前加载）
	require("core.options")
	require("core.keymaps")

	-- UI 插件
	require("ui.lualine")
	require("ui.bufferline")

	-- 工具插件
	require("util.telescope")
	require("util.gitsigns")

	-- LSP
	require("lsp.mason")
	require("lsp.lspsaga")
end
