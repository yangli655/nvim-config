require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
-- mason-lspconfig 的 ensure_installed 只认 nvim-lspconfig 的 server 名，
-- 它内部通过 mappings 再转成 mason-registry 包名。如果写成包名，启动时会
-- 报 "is not a valid entry in ensure_installed"，且对应 LSP 不会被安装/启用。
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"bashls",
		"clangd",
		"pyright",
		"yamlls",
		"jsonls",
	},
	automatic_enable = true,
})
