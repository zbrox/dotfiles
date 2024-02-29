-- Tree view
return
{
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local function on_attach(bufnr)
            local api = require "nvim-tree.api"

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            vim.keymap.set('n', '<leader>b', '<cmd>NvimTreeToggle<CR>', { desc = "Show tree view" })
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        end

        require('nvim-tree').setup {
            disable_netrw = true,
            hijack_netrw = true,
            view = {
                number = true,
                relativenumber = true,
            },
            filters = {
                custom = { ".git" },
            },
            on_attach = on_attach,
        }
    end,
}
