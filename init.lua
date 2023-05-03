if (not vim.g.vscode) then
    require("setup")

    require("core.options")
    require("core.keymaps")

    require("lsp.mason")
    require("lsp.lspsaga")
    require("lsp.cmp")

    require("ui.alpha")
    require("ui.github-theme")
    require("ui.nvim-tree")
    require("ui.lualine")
    require("ui.bufferline")
    require("ui.cursorline")
    require("ui.indent-blackline")

    require("util.autopairs")
    require("util.comment")
    require("util.persisted")
    require("util.telescope")
    require("util.treesitter")
    require("util.toggleterm")
    require("util.which-key")
end
