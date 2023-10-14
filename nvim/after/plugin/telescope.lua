local builtin = require('telescope.builtin')
-- find files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- find within git files (project find)
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- ripgrep within the project files
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
-- search within open buffers
vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
