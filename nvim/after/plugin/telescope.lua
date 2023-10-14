local builtin = require('telescope.builtin')
-- find files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- find within git files (project find)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
