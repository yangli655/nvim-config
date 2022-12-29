if (not vim.g.vscode) then
    require "basic"
    require "keymaps"
    require "plugins"

    require "plugins-config"
    require "plugins-config.bufferline"
    require "plugins-config.indent_blankline"
    require "plugins-config.nvim-tree"
    require "plugins-config.nvim-treesitter"
    require "plugins-config.lspconfig"
    require "plugins-config.lspsaga"
    require "plugins-config.telescope"
    require "plugins-config.cmp"
    require "plugins-config.nvim-cursorline"
    require "plugins-config.toggleterm"
end
