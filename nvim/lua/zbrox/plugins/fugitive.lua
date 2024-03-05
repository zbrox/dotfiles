-- Git
return {
    'tpope/vim-fugitive',
    keys = {
        -- git status
        { "n", "<leader>gs", vim.cmd.Git, desc = "Show git status" },
    }
}
