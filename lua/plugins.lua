-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local use = require('packer').use

return require('packer').startup({
    function()
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
            'goolord/alpha-nvim',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = function ()
                require'alpha'.setup(require'alpha.themes.startify'.config)
            end
        }

        use "lukas-reineke/indent-blankline.nvim"
        use "yamatsum/nvim-cursorline"

        -- using bufferline.nvim
        use {
            'akinsho/bufferline.nvim',
            tag = "*",
            requires = 'kyazdani42/nvim-web-devicons'
        }

        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons', opt = true }
        }

        use {
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons', -- optional, for file icon
            }
        }

        -- If you are using Packer
        use 'marko-cerovac/material.nvim'

        -- Collection of configurations for the built-in LSP client
        use 'neovim/nvim-lspconfig'

        use {
            'nvim-telescope/telescope.nvim',
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
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
        }

        use "hrsh7th/nvim-cmp" -- The completion plugin
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer" -- buffer completions
        use "hrsh7th/cmp-path" -- path completions
        use "hrsh7th/cmp-cmdline" -- cmdline completions
        -- For luasnip users
        use "L3MON4D3/LuaSnip"
        use "saadparwaiz1/cmp_luasnip"

        use { "akinsho/toggleterm.nvim"}

        use "terrortylor/nvim-comment"

        use "windwp/nvim-autopairs"
    end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    }
})
