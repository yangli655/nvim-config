-- https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
    -- -- UI setting --
    {
        'projekt0n/github-nvim-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                -- ...
            })

            vim.cmd('colorscheme github_dark')
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
        'willothy/veil.nvim',
        lazy = false,
        dependencies = {
            -- All optional, only required for the default setup.
            -- If you customize your config, these aren't necessary.
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim"
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
        }
    },

    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },

    "lukas-reineke/indent-blankline.nvim",
    "yamatsum/nvim-cursorline",

    -- uilts setting --
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },

    {
        "numToStr/Comment.nvim",
        lazy = true,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },

    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true
    },

    {
        "olimorris/persisted.nvim",
        config = true
    },
    -- {
    --     "folke/which-key.nvim",
    --     event = "VeryLazy",
    --     init = function()
    --         vim.o.timeout = true
    --         vim.o.timeoutlen = 300
    --     end,
    --     opts = {
    --         -- your configuration comes here
    --         -- or leave it empty to use the default settings
    --         -- refer to the configuration section below
    --     }
    -- }

    -- LSP --
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate" -- :MasonUpdate updates registry contents
    },

    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    {
        'nvimdev/lspsaga.nvim',
        config = true,
        -- dependencies = {
        --     'nvim-treesitter/nvim-treesitter', -- optional
        --     'nvim-tree/nvim-web-devicons',     -- optional
        --     'williamboman/mason-lspconfig.nvim',
        --     'neovim/nvim-lspconfig',
        -- }
    },

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",  -- buffer completions
    "hrsh7th/cmp-path",    -- path completions
    "hrsh7th/cmp-cmdline", -- cmdline completions
    "hrsh7th/nvim-cmp",    -- The completion plugin
    -- For luasnip users
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    {
        "mhartington/formatter.nvim",
        lazy = true,
    },
})
