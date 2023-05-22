local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert Mode --
keymap("i", "jk", "<ESC>", opts)

-- Normal Mode --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

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

-- Comment.nvim --
-- NORMAL mode
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `[count]gcc` - Toggles the number of line given as a prefix-count using linewise
-- `[count]gbc` - Toggles the number of line given as a prefix-count using blockwise
-- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- `gb[count]{motion}` - (Op-pending) Toggles the region using blockwise comment
-- `gco` - Insert comment to the next line and enters INSERT mode
-- `gcO` - Insert comment to the previous line and enters INSERT mode
-- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- VISUAL mode
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

-- Telescope --
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Persisted --
vim.keymap.set("n", "<leader>sp", function() vim.cmd("Telescope persisted") end)
vim.keymap.set("n", "<leader>sl", function() vim.cmd("SessionLoadLast") end)

-- Formatter.nvim --
keymap("n", "<leader>f", ":Format<cr>", opts)
keymap("n", "<leader>F", ":FormatWrite<cr>", opts)
-- Format after save --
vim.cmd([[    
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]])
