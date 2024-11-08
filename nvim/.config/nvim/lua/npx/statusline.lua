return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "npx.buffer-management" },
    config = function()
        local tracked_buffers = require("npx.buffer-management").tracked_buffers_lualine

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = 'everforest',
                component_separators = {left = '', right = ''},
                section_separators = {left = '', right = ''},
                disabled_filetypes = {statusline = {'qf'}, winbar = {}},
                ignore_focus = {'qf'}, -- TODO check this option
                always_divide_middle = true,
                globalstatus = true,
                refresh = {statusline = 200, tabline = 1000, winbar = 1000}
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {tracked_buffers},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {
                lualine_b = {'branch'},
                lualine_c = {'filename'},
                lualine_x = {},
                lualine_y = {'filetype', 'fileformat'},
                lualine_z = {'location'}
            }
        })
    end
}
