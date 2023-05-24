local buffers = require("npx.buffer-management").tracked_buffers

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = 'ayu_mirage',
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
        disabled_filetypes = {statusline = {}, winbar = {}},
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {statusline = 200, tabline = 1000, winbar = 1000}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {buffers},
        lualine_x = {'fileformat', 'filetype'},
        lualine_y = {},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {}
})

