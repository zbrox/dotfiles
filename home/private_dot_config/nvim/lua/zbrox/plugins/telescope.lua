-- Fuzzy find
return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        -- find files
        { 'n', '<leader>pf', function() require 'telescope.builtin'.find_files() end, desc = "Find files in project" },
        -- find within git files (project find)
        { 'n', '<leader>pg', function() require 'telescope.builtin'.git_files() end,  desc = "Find files in git repo" },
        -- ripgrep within the project files
        { 'n', '<leader>pr', function() require 'telescope.builtin'.live_grep() end,  desc = "Ripgrep in project files" },
        -- search within open buffers
        { 'n', '<leader>pb', function() require 'telescope.builtin'.buffers() end,    desc = "Show open buffers" },
    }
}