require('nvim-tree').setup{
    disable_netrw = true,
    hijack_netrw = true,
    view = {
      number = true,
      relativenumber = true,
    },
    filters = {
      custom = { ".git" },
    }
}

-- Nvim Tree
vim.keymap.set("n", "<leader>tv", ':NvimTreeToggle<CR>', { desc = "Show tree view" })
