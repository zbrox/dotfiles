require("trouble").setup()

vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
{silent = true, noremap = true, desc = "Toggle trouble quickfix"}
)
