-- https://github.com/folke/lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
		"projekt0n/github-nvim-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("github-theme").setup({
				-- ...
			})

			vim.cmd("colorscheme github_dark")
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
		"willothy/veil.nvim",
		lazy = false,
		dependencies = {
			-- All optional, only required for the default setup.
			-- If you customize your config, these aren't necessary.
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = true,
		-- or configure with:
		-- opts = { ... }
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
		opts = {},
	},
	{
		"delphinus/auto-cursorline.nvim",
		config = function()
			require("auto-cursorline").setup({})
		end,
	},

	-- uilts setting --
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},

	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		config = true,
	},

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

	{
		"olimorris/persisted.nvim",
		lazy = false, -- make sure the plugin is always loaded at startup
		config = true,
	},

	-- LSP --
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	{
		"nvimdev/lspsaga.nvim",
		config = true,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},

	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"hrsh7th/nvim-cmp", -- The completion plugin
	-- For luasnip users
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	{
		"mhartington/formatter.nvim",
		lazy = true,
	},
	pkg = {
		enabled = true,
		cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
		versions = true, -- Honor versions in pkg sources
		-- the first package source that is found for a plugin will be used.
		sources = {
			"lazy",
			"packspec",
		},
	},
	rocks = {
		enabled = false,
		-- hererocks = false,
	},
	-- automatically check for plugin updates
	checker = { enabled = true },
})
