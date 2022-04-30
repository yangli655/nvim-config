local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- better buffer op --
keymap("n", "bn", ":bnext<cr>", opts)
keymap("n", "bp", ":bprev<cr>", opts)
keymap("n", "bd", ":bdetele<cr>", opts)

-- better tab op --
keymap("n", "tn", ":tabnew<cr>", opts)
keymap("n", "tj", ":tabnext<cr>", opts)
keymap("n", "tk", ":tabprev<cr>", opts)
keymap("n", "tc", ":tabclose<cr>", opts)

-- nvim-tree --
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
keymap("n", "<leader>f", ":NvimTreeFindFile<cr>", opts)

-- bufferline --
keymap("n", "bbp", ":BufferLinePick<cr>", opts)

