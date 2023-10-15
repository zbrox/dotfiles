require('nvim-tree').setup{}

-- Nvim Tree
vim.keymap.set("n", "<leader>tv", ':NvimTreeToggle<CR>', { desc = "Show tree view" })
