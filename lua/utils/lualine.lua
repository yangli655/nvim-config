-- https://github.com/nvim-lualine/lualine.nvim
-- https://github.com/WhoIsSethDaniel/lualine-lsp-progress.nvim

require('lualine').setup {
    sections = {
        lualine_c = {
            --   ...,
            'lsp_progress',
        }
    }
}
