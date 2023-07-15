vim.opt.termguicolors = true
local bufferline = require("bufferline")
bufferline.setup {
    options = {
        mode = "buffers",                               -- set to "tabs" to only show tabpages instead
        style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
        themable = true,
        numbers = "ordinal",
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'underline',
        },
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                separator = true
            }
        },
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true, -- whether to show duplicate buffer prefix

        hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
        },
    }
}
