-- Leader
vim.g.mapleader = " "
vim.g.localmapleader = "\\"

-- Project View
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Show project view"})

-- Better escape using jk in insert and terminal mode
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })
vim.keymap.set("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
vim.keymap.set("t", "jj", "<C-\\><C-n>", { noremap = true, silent = true })

-- Switch buffer
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })
