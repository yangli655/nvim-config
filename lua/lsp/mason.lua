require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
-- 注意：这里要用 mason-registry 的包名，不是 nvim-lspconfig 的 server 名。
-- lua_ls / bashls / yamlls / jsonls 在 mason 里查不到，会被静默跳过。
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua-language-server",
		"bash-language-server",
		"clangd",
		"pyright",
		"yaml-language-server",
		"json-lsp",
	},
	automatic_enable = true,
})
