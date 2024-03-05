-- Nicer buffer line
return
{
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local bufferline = require("bufferline")

        bufferline.setup {
            options = {
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "Explorer",
                        separator = true,
                        text_align = "center"
                    }
                },
                diagnostics = "nvim_lsp",
                separator_style = { "", "" },
                modified_icon = '●',
                buffer_close_icon = '×',
            }
        }
    end
}
