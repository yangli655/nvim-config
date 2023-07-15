if (not vim.g.vscode) then
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup(plugins, opts)

    require("core.options")
    require("core.keymaps")

    require("ui.github-theme")
    require("ui.nvim-tree")
    require("ui.lualine")
    require("ui.bufferline")
    require("ui.cursorline")
    require("ui.indent-blackline")

    require("util.autopairs")
    require("util.comment")
    require("util.telescope")
    require("util.treesitter")
    require("util.toggleterm")

    require("lsp.mason")
    require("lsp.lspsaga")
    require("lsp.cmp")
    require("lsp.formatter")
end
