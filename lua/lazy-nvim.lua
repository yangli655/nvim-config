-- https://github.com/folke/lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	-- -- UI setting --
	{
		"goolord/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("alpha").setup(require("alpha.themes.theta").config)
		end,
	},

	{
		"projekt0n/github-nvim-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({
				-- ...
			})

			vim.cmd("colorscheme github_dark_colorblind")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},

	{
		"kylechui/nvim-surround",
		version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
				--     Old text                    Command         New text
				-- --------------------------------------------------------------------------------
				--     surr*ound_words             ysiw)           (surround_words)
				--     surr*ound_words             ysiw(           ( surround_words )
				--     *make strings               ys$"            "make strings"
				--     [delete ar*ound me!]        ds]             delete around me!
				--     remove <b>HTML t*ags</b>    dst             remove HTML tags
				--     'change quot*es'            cs'"            "change quotes"
				--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
				--     delete(functi*on calls)     dsf             function calls
			})
		end,
	},

	-- uilts setting --
	"lewis6991/gitsigns.nvim",

	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- optional but recommended
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	{
		"saghen/blink.pairs",
		version = "*", -- (recommended) only required with prebuilt binaries

		-- download prebuilt binaries from github releases
		dependencies = "saghen/blink.download",
		-- OR build from source, requires nightly:
		-- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				-- you can call require("blink.pairs.mappings").enable()
				-- and require("blink.pairs.mappings").disable()
				-- to enable/disable mappings at runtime
				enabled = true,
				cmdline = true,
				-- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
				-- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
				disabled_filetypes = {},
				-- see the defaults:
				-- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
				pairs = {},
			},
			highlights = {
				enabled = true,
				-- requires require('vim._extui').enable({}), otherwise has no effect
				cmdline = true,
				groups = {
					"BlinkPairsOrange",
					"BlinkPairsPurple",
					"BlinkPairsBlue",
				},
				unmatched_group = "BlinkPairsUnmatched",

				-- highlights matching pairs under the cursor
				matchparen = {
					enabled = true,
					-- known issue where typing won't update matchparen highlight, disabled by default
					cmdline = false,
					-- also include pairs not on top of the cursor, but surrounding the cursor
					include_surrounding = false,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
			},
			debug = false,
		},
	},
	{
		"saghen/blink.indent",
		--- @module 'blink.indent'
		--- @type blink.indent.Config
		opts = {
			blocked = {
				-- default: 'terminal', 'quickfix', 'nofile', 'prompt'
				buftypes = { include_defaults = true },
				-- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
				filetypes = { include_defaults = true },
			},
			mappings = {
				-- which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
				border = "both",
				-- set to '' to disable
				-- textobjects (e.g. `y2ii` to yank current and outer scope)
				object_scope = "ii",
				object_scope_with_border = "ai",
				-- motions
				goto_top = "[i",
				goto_bottom = "]i",
			},
			static = {
				enabled = true,
				char = "▎",
				whitespace_char = nil, -- inherits from `vim.opt.listchars:get().space` when `nil` (see `:h listchars`)
				priority = 1,
				-- specify multiple highlights here for rainbow-style indent guides
				-- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
				highlights = { "BlinkIndent" },
			},
			scope = {
				enabled = true,
				char = "▎",
				priority = 1000,
				-- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
				-- highlights = { 'BlinkIndentScope' },
				-- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
				highlights = { "BlinkIndentOrange", "BlinkIndentViolet", "BlinkIndentBlue" },
				-- enable to show underlines on the line above the current scope
				underline = {
					enabled = false,
					-- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
					highlights = {
						"BlinkIndentOrangeUnderline",
						"BlinkIndentVioletUnderline",
						"BlinkIndentBlueUnderline",
					},
				},
			},
		},
	},
	-- LSP --
	"mason-org/mason.nvim",
	"mason-org/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},

	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = true } },
			signature = { enabled = true },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = function(bufnr)
						if require("conform").get_formatter_info("ruff_format", bufnr).available then
							return { "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					bash = { "shfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					yaml = { "yamlfmt" },
					json = { "jq" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},

	{
		"rmagatti/auto-session",
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			-- log_level = 'debug',
			cwd_change_handling = true,
			post_cwd_changed_cmds = {
				function()
					require("lualine").refresh() -- example refreshing the lualine status line _after_ the cwd changes
				end,
			},
			git_use_branch_name = true,
			git_auto_restore_on_branch_change = true,
		},
	},

	rocks = {
		enabled = false,
		-- hererocks = false,
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
