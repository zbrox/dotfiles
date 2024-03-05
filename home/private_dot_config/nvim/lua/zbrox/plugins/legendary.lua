-- Command palette
return
{
    "mrjones2014/legendary.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    config = function()
        require("legendary").setup {
            extensions = {
                nvim_tree = true,
                which_key = {
                    auto_register = true
                }
            },
        }
    end,
    keys = {
        { "n", "<C-p>", "<cmd>Legendary<cr>", desc = "Command Palette" }
    }
}
