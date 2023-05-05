vim.opt.termguicolors = true
require("bufferline").setup {
    options = {
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
        },
    }
}
