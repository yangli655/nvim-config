if (not vim.g.vscode) then
    require "basic"
    require "keymaps"
    require "plugins"

    require "ui.alpha"
    require "ui.github-nvim-theme"
    require "ui.noice"

    require "lsp.cmp"
    require "lsp.lspsoga"
    require "lsp.lspkind"
    require "lsp.mason"

    require "utils.autopairs"
    require "utils.bufferline"
    require "utils.comment"
    require "utils.lualine"
    require "utils.nvim-cursorline"
    require "utils.nvim-tree"
    require "utils.nvim-treesitter"
    require "utils.telescope"
    require "utils.persisted"
    require "utils.toggleterm"
    -- require "utils.which-key"
end
