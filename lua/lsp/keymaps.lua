-- LSP 快捷键配置（兼容原 lspsaga 快捷键）
local keymap = vim.keymap.set

-- 等待 LSP 附加时设置快捷键
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf, noremap = true, silent = true }

		-- Finder (gh) - 使用 telescope 替代
		keymap("n", "gh", function()
			require("telescope.builtin").lsp_definitions()
		end, vim.tbl_extend("force", opts, { desc = "LSP Finder" }))

		-- Code action (<leader>ca)
		keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))

		-- Rename (gr)
		keymap("n", "gr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))

		-- Go to definition (gd)
		keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))

		-- Peek definition (gp) - 使用 telescope preview
		keymap("n", "gp", function()
			require("telescope.builtin").lsp_definitions({ jump_type = "never" })
		end, vim.tbl_extend("force", opts, { desc = "Peek Definition" }))

		-- Go to type definition (gt)
		keymap("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))

		-- Hover doc (K)
		keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))

		-- Diagnostic jump
		keymap("n", "[e", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
		keymap("n", "]e", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))

		-- Diagnostic jump with severity filter
		keymap("n", "[E", function()
			vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
		end, vim.tbl_extend("force", opts, { desc = "Previous Error" }))
		keymap("n", "]E", function()
			vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
		end, vim.tbl_extend("force", opts, { desc = "Next Error" }))

		-- Show diagnostics
		keymap("n", "<leader>sl", function()
			vim.diagnostic.open_float({ scope = "line" })
		end, vim.tbl_extend("force", opts, { desc = "Show Line Diagnostics" }))
		keymap("n", "<leader>sb", function()
			vim.diagnostic.open_float({ scope = "buffer" })
		end, vim.tbl_extend("force", opts, { desc = "Show Buffer Diagnostics" }))
		keymap("n", "<leader>sw", function()
			require("trouble").toggle({ mode = "workspace_diagnostics" })
		end, vim.tbl_extend("force", opts, { desc = "Show Workspace Diagnostics" }))
		keymap("n", "<leader>sc", function()
			vim.diagnostic.open_float({ scope = "cursor" })
		end, vim.tbl_extend("force", opts, { desc = "Show Cursor Diagnostics" }))

		-- Outline (<leader>o)
		keymap("n", "<leader>o", function()
			require("trouble").toggle({ mode = "symbols" })
		end, vim.tbl_extend("force", opts, { desc = "Outline" }))

		-- Call hierarchy
		keymap("n", "<leader>ci", function()
			require("telescope.builtin").lsp_incoming_calls()
		end, vim.tbl_extend("force", opts, { desc = "Incoming Calls" }))
		keymap("n", "<leader>co", function()
			require("telescope.builtin").lsp_outgoing_calls()
		end, vim.tbl_extend("force", opts, { desc = "Outgoing Calls" }))

		-- References
		keymap("n", "gR", function()
			require("telescope.builtin").lsp_references()
		end, vim.tbl_extend("force", opts, { desc = "References" }))

		-- Implementation
		keymap("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
	end,
})

-- LSP 自动检测并启用折叠
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LSPFolding", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
