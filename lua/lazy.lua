-- https://github.com/folke/lazy.nvim

return {
    -- UI setting --
    {
        'goolord/alpha-nvim',
        event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            require 'alpha.themes.startify'.config
        }
    },
    "projekt0n/github-nvim-theme",
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
    "numToStr/Comment.nvim",
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
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons',     -- optional
        }
    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",  -- buffer completions
    "hrsh7th/cmp-path",    -- path completions
    "hrsh7th/cmp-cmdline", -- cmdline completions
    "hrsh7th/nvim-cmp",    -- The completion plugin
    -- For luasnip users
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    "mhartington/formatter.nvim",
}
