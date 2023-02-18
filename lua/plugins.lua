-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.cmd [[packadd packer.nvim]]

return require('packer').startup({
    function()
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
            'goolord/alpha-nvim',
            requires = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require 'alpha'.setup(require 'alpha.themes.startify'.config)
            end
        }

        use({
            'projekt0n/github-nvim-theme',
            tag = 'v0.0.7',
            -- or branch = '0.0.x'
            config = function()
                require('github-theme').setup({
                    -- ...
                })
            end
        })

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

        use {
            'yamatsum/nvim-cursorline',
            config = function()
                require('nvim-cursorline').setup {
                    cursorline = {
                        enable = true,
                        timeout = 1000,
                        number = false,
                    },
                    cursorword = {
                        enable = true,
                        min_length = 3,
                        hl = { underline = true },
                    }
                }
            end
        }

        use {
            'akinsho/bufferline.nvim',
            tag = "v3.*",
            requires = 'nvim-tree/nvim-web-devicons',
            config = function()
                -- set termguicolors to enable highlight groups
                vim.opt.termguicolors = true
                require("bufferline").setup {}
            end
        }

        use {
            'nvim-lualine/lualine.nvim',
            requires = {
                'nvim-tree/nvim-web-devicons',
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
            tag = 'nightly', -- optional, updated every week.
            config = function()
                -- disable netrw at the very start of your init.lua (strongly advised)
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
                require("nvim-tree").setup()
            end
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
        use 'neovim/nvim-lspconfig'

        use({
            "glepnir/lspsaga.nvim",
            branch = "main",
            config = function()
                require('lspsaga').setup({})
            end,
            requires = {
                { "nvim-tree/nvim-web-devicons" },
                --Please make sure you install markdown and markdown_inline parser
                { "nvim-treesitter/nvim-treesitter" }
            }
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

        use {
            "folke/which-key.nvim",
            config = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require("which-key").setup {
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                }
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
