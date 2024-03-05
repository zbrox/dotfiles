-- Pretty diagnostics
return {
    "folke/trouble.nvim",
    keys = {
        { "n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true, desc = "Toggle trouble quickfix" } },
    }
}