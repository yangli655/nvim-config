local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert Mode --
keymap("i", "jk", "<ESC>", opts)
keymap("i", "<up>", "<nop>", opts)
keymap("i", "<down>", "<nop>", opts)
keymap("i", "<left>", "<nop>", opts)
keymap("i", "<right>", "<nop>", opts)

-- Normal Mode --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<up>", "<nop>", opts)
keymap("n", "<down>", "<nop>", opts)
keymap("n", "<left>", "<nop>", opts)
keymap("n", "<right>", "<nop>", opts)

-- better buffer op --
keymap("n", "bn", ":bnext<cr>", opts)
keymap("n", "bp", ":bprev<cr>", opts)
keymap("n", "bd", ":bdelete<cr>", opts)

-- better tab op --
keymap("n", "tn", ":tabnew<cr>", opts)
keymap("n", "tj", ":tabnext<cr>", opts)
keymap("n", "tk", ":tabprev<cr>", opts)
keymap("n", "tc", ":tabclose<cr>", opts)

-- Nvim Tree --
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- BufferLine --
-- bufferline pick --
-- bufferline --
keymap("n", "bh", ":BufferLinePick<cr>", opts)
keymap("n", "bH", ":BufferLinePickClose<cr>", opts)

-- Telescope --
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- Formatter.nvim --
keymap("n", "<leader>f", ":Format<cr>", opts)
keymap("n", "<leader>F", ":FormatWrite<cr>", opts)
-- Format after save --
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})
