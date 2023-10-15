local bufferline = require("bufferline")

bufferline.setup {
    options = {
          offsets = {
            {
                filetype = "NvimTree",
                text="Explorer",
                separator= true,
                text_align = "center"
            }
          },
          diagnostics = "nvim_lsp",
          separator_style = {"", ""},
          modified_icon = '●',
          buffer_close_icon = '×',
      }
}
