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
			lazy = true,
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		-- opts = {},
		config = function()
			require("ibl").setup({})
		end,
	},

	{
		"delphinus/auto-cursorline.nvim",
		config = function()
			require("auto-cursorline").setup({})
		end,
	},

	-- uilts setting --
	"lewis6991/gitsigns.nvim",

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},

	-- LSP --
	"mason-org/mason.nvim",
	"mason-org/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	{
		"nvimdev/lspsaga.nvim",
		config = true,
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
		"saghen/blink.pairs",
		version = "*", -- (recommended) only required with prebuilt binaries

		-- download prebuilt binaries from github releases
		dependencies = "saghen/blink.download",
		-- -- OR build from source
		-- build = "cargo build --release",
		-- -- OR build from source with nix
		-- build = "nix run .#build-plugin",

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				-- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
				enabled = true,
				-- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L10
				pairs = {},
			},
			highlights = {
				enabled = true,
				groups = {
					"BlinkPairsOrange",
					"BlinkPairsPurple",
					"BlinkPairsBlue",
				},
				matchparen = {
					enabled = true,
					group = "MatchParen",
				},
			},
			debug = false,
		},
	},

	{
		"mhartington/formatter.nvim",
		lazy = true,
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
			post_cwd_changed_cmds = {
				function()
					require("lualine").refresh() -- example refreshing the lualine status line _after_ the cwd changes
				end,
			},
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
