require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "bashls", "clangd", "pyright", "yamlls", "jsonls" },
	automatic_enable = true,
})
