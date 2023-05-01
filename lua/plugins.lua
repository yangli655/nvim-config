-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup({
    function()
        -- Packer can manage itself
        use "wbthomason/packer.nvim"

        use {
            'goolord/alpha-nvim',
            requires = { 'nvim-tree/nvim-web-devicons' },
        }

        use({
            'projekt0n/github-nvim-theme',
            tag = 'v0.0.7',
            -- or branch = '0.0.x'
        })

        use {
            "folke/noice.nvim",
            requires = {
                -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                "MunifTanjim/nui.nvim",
                -- OPTIONAL:
                --   `nvim-notify` is only needed, if you want to use the notification view.
                --   If not available, we use `mini` as the fallback
                "rcarriga/nvim-notify",
            }
        }

        use {
            'lukas-reineke/indent-blankline.nvim',
            config = function()
                vim.opt.list = true
                vim.opt.listchars:append("eol:↴")
                require("indent_blankline").setup {
                    show_end_of_line = true,
                }
            end
        }

        use "yamatsum/nvim-cursorline"

        use {
            'akinsho/bufferline.nvim',
            tag = "*",
            requires = 'nvim-tree/nvim-web-devicons',
        }

        use "WhoIsSethDaniel/lualine-lsp-progress.nvim"

        use {
            'nvim-lualine/lualine.nvim',
            requires = {
                'nvim-tree/nvim-web-devicons',
                opt = true
            },
        }

        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
            tag = 'nightly',                   -- optional, updated every week.
        }

        use {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.1',
            -- or branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }

        use {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'make'
        }

        -- Treesittetr
        use {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
        }

        -- Collection of configurations for the built-in LSP client
        -- use "neovim/nvim-lspconfig"
        use "onsails/lspkind.nvim"

        use({
            "glepnir/lspsaga.nvim",
            opt = true,
            branch = "main",
            event = "LspAttach",
            -- config = function()
            --     require('lspsaga').setup({})
            -- end,
            requires = {
                { "nvim-tree/nvim-web-devicons" },
                --Please make sure you install markdown and markdown_inline parser
                { "nvim-treesitter/nvim-treesitter" }
            }
        })

        use {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        }

        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer"  -- buffer completions
        use "hrsh7th/cmp-path"    -- path completions
        use "hrsh7th/cmp-cmdline" -- cmdline completions
        use "hrsh7th/nvim-cmp"    -- The completion plugin

        -- For luasnip users
        use "L3MON4D3/LuaSnip"
        use "saadparwaiz1/cmp_luasnip"

        use {
            "akinsho/toggleterm.nvim",
            tag = '*'
        }

        use "numToStr/Comment.nvim"

        use "windwp/nvim-autopairs"

        use "olimorris/persisted.nvim"

        use "folke/which-key.nvim"
    end,
    config = {
        display = {
            open_fn = require('packer.util').float,
        },
        profile = {
            enable = true,
            threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
        }
    }
})
