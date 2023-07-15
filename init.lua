if (not vim.g.vscode) then
    require("lazy-nvim")

    require("core.options")
    require("core.keymaps")

    require("ui.nvim-tree")
    require("ui.lualine")
    require("ui.bufferline")
    require("ui.cursorline")
    require("ui.indent-blackline")

    require("util.comment")
    require("util.telescope")
    require("util.treesitter")
    require("util.toggleterm")

    require("lsp.mason")
    require("lsp.lspsaga")
    require("lsp.cmp")
    require("lsp.formatter")
end
