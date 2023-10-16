local legendary = require("legendary")

legendary.setup {
    extensions = {
        nvim_tree = true,
        which_key = {
            auto_register = true
        }
    },
}

vim.keymap.set("n", "<C-p>", "<cmd>Legendary<cr>", { desc = "Command Palette" })
