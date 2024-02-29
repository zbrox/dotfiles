-- Tree view
return
{
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
        { "n", "<C-b>", ':NvimTreeToggle<CR>', desc = "Show tree view" }
    },
    config = function()
        require('nvim-tree').setup {
            disable_netrw = true,
            hijack_netrw = true,
            view = {
                number = true,
                relativenumber = true,
            },
            filters = {
                custom = { ".git" },
            }
        }
    end,
}