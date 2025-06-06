-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,
		},
		python = {
			require("formatter.filetypes.python").ruff,
		},
		yaml = {
			require("formatter.filetypes.yaml").yamlfmt,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},
		cpp = {
			function()
				return {
					exe = "clang-format",
					args = {
						"--style='{BasedOnStyle: llvm, IndentWidth: 4}'",
						util.escape_path(util.get_current_buffer_file_name()),
					},
					stdin = true,
					try_node_module = true,
				}
			end,
		},
		c = {
			function()
				return {
					exe = "clang-format",
					args = {
						"--style='{BasedOnStyle: llvm, IndentWidth: 4}'",
						util.escape_path(util.get_current_buffer_file_name()),
					},
					stdin = true,
					try_node_module = true,
				}
			end,
		},
	},
})
