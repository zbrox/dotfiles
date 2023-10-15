local builtin = require('telescope.builtin')
-- find files
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find files in project" })
-- find within git files (project find)
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = "Find files in git repo" })
-- ripgrep within the project files
vim.keymap.set('n', '<leader>pr', builtin.live_grep, { desc = "Ripgrep in project files" })
-- search within open buffers
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Show open buffers" })
