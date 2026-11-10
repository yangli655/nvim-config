if not vim.g.vscode then
	require("lazy-nvim")

	-- 基础配置（必须在 UI 插件之前加载）
	require("core.options")
	require("core.keymaps")

	-- UI 插件
	require("ui.lualine")
	require("ui.bufferline")

	-- 工具插件
	require("util.gitsigns")

	-- LSP
	require("lsp.lua_ls") -- 必须在 lsp.mason 之前：给 lua_ls 补 settings 后再启用
	require("lsp.mason")
	require("lsp.lspsaga")
end
