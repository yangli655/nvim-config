local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert --
keymap("i", "jk", "<ESC>", opts)

-- Normal --
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

-- nvim-tree --
-- default mappings
-- local list = {
--     { key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
--     { key = "<C-e>",                        action = "edit_in_place" },
--     { key = {"O"},                          action = "edit_no_picker" },
--     { key = {"<2-RightMouse>", "<C-]>"},    action = "cd" },
--     { key = "<C-v>",                        action = "vsplit" },
--     { key = "<C-x>",                        action = "split" },
--     { key = "<C-t>",                        action = "tabnew" },
--     { key = "<",                            action = "prev_sibling" },
--     { key = ">",                            action = "next_sibling" },
--     { key = "P",                            action = "parent_node" },
--     { key = "<BS>",                         action = "close_node" },
--     { key = "<Tab>",                        action = "preview" },
--     { key = "K",                            action = "first_sibling" },
--     { key = "J",                            action = "last_sibling" },
--     { key = "I",                            action = "toggle_git_ignored" },
--     { key = "H",                            action = "toggle_dotfiles" },
--     { key = "R",                            action = "refresh" },
--     { key = "a",                            action = "create" },
--     { key = "d",                            action = "remove" },
--     { key = "D",                            action = "trash" },
--     { key = "r",                            action = "rename" },
--     { key = "<C-r>",                        action = "full_rename" },
--     { key = "x",                            action = "cut" },
--     { key = "c",                            action = "copy" },
--     { key = "p",                            action = "paste" },
--     { key = "y",                            action = "copy_name" },
--     { key = "Y",                            action = "copy_path" },
--     { key = "gy",                           action = "copy_absolute_path" },
--     { key = "[c",                           action = "prev_git_item" },
--     { key = "]c",                           action = "next_git_item" },
--     { key = "-",                            action = "dir_up" },
--     { key = "s",                            action = "system_open" },
--     { key = "q",                            action = "close" },
--     { key = "g?",                           action = "toggle_help" },
--     { key = "W",                            action = "collapse_all" },
--     { key = "S",                            action = "search_node" },
--     { key = "<C-k>",                        action = "toggle_file_info" },
--     { key = ".",                            action = "run_file_command" }
--   }
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- bufferline --
keymap("n", "bbp", ":BufferLinePick<cr>", opts)

-- telescope --
-- Mappings	            Action
-- <C-n>/<Down>	        Next item
-- <C-p>/<Up>	        Previous item
-- j/k	                Next/previous (in normal mode)
-- H/M/L	            Select High/Middle/Low (in normal mode)
-- 'gg/G'	            Select the first/last item (in normal mode)
-- <CR>	                Confirm selection
-- <C-x>	            Go to file selection as a split
-- <C-v>	            Go to file selection as a vsplit
-- <C-t>	            Go to a file in a new tab
-- <C-u>	            Scroll up in preview window
-- <C-d>	            Scroll down in preview window
-- <C-/>	            Show mappings for picker actions (insert mode)
-- ?	                Show mappings for picker actions (normal mode)
-- <C-c>	            Close telescope
-- <Esc>	            Close telescope (in normal mode)
-- <Tab>	            Toggle selection and move to next selection
-- <S-Tab>	            Toggle selection and move to prev selection
-- <C-q>	            Send all items not filtered to quickfixlist (qflist)
-- <M-q>	            Send all selected items to qflist

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
