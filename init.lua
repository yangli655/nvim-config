if (not vim.g.vscode) then
    require "basic"
    require "keymaps"
    require "plugins"

    require "plugins-config"
    require "plugins-config.nvim-treesitter"
    require "plugins-config.telescope"
    require "plugins-config.cmp"
    require "plugins-config.toggleterm"
end
