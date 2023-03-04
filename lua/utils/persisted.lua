-- https://github.com/olimorris/persisted.nvim

require("persisted").setup({
    autosave = true,
    autoload = true,
})

vim.keymap.set("n", "<leader>sp", function() vim.cmd("Telescope persisted") end)
vim.keymap.set("n", "<leader>sl", function() vim.cmd("SessionLoadLast") end)
