-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.cmd [[packadd packer.nvim]]

return require('packer').startup({
    function()
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
            'goolord/alpha-nvim',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = function()
                require 'alpha'.setup(require 'alpha.themes.startify'.config)
            end
        }

        use({
            'projekt0n/github-nvim-theme',
            config = function()
                require('github-theme').setup({
                    -- ...
                })
            end
        })

        use "lukas-reineke/indent-blankline.nvim"
        use "yamatsum/nvim-cursorline"

        -- using bufferline.nvim
        use {
            'akinsho/bufferline.nvim',
            tag = "v3.*",
            requires = 'kyazdani42/nvim-web-devicons'
        }

        use {
            'nvim-lualine/lualine.nvim',
            requires = {
                'kyazdani42/nvim-web-devicons',
                opt = true
            },
            config = function()
                require('lualine').setup()
            end
        }

        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
            tag = 'nightly' -- optional, updated every week. (see issue #1193)
        }

        use {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.0',
            requires = {
                { 'nvim-lua/plenary.nvim' }
            }
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
        use 'neovim/nvim-lspconfig'

        use({
            "glepnir/lspsaga.nvim",
            branch = "main",
            config = function()
                require('lspsaga').setup({})
            end,
        })

        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer" -- buffer completions
        use "hrsh7th/cmp-path" -- path completions
        use "hrsh7th/cmp-cmdline" -- cmdline completions
        use "hrsh7th/nvim-cmp" -- The completion plugin

        -- For luasnip users
        use "L3MON4D3/LuaSnip"
        use "saadparwaiz1/cmp_luasnip"

        use {
            "akinsho/toggleterm.nvim",
            tag = '*'
        }

        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }

        use {
            "windwp/nvim-autopairs",
            config = function()
                require("nvim-autopairs").setup {}
            end
        }
    end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    }
})
