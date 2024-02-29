-- Better undo
return {
    'mbbill/undotree',
    keys = {
        { "n", "<leader>u", vim.cmd.UndotreeToggle, desc = "Show undo history" }
    }
}