return {
    config = function()
        -- Const
        local BUF_TRACKED = 'npx_tracked'

        -- Util
        local cmd = function(cmd) return function() vim.cmd(cmd); end end

        local id = vim.api.nvim_create_augroup("npx_buffer_management", {clear = true})

        local autocmd = function(events, callback)
            vim.api.nvim_create_autocmd(events, {
                group = id,
                pattern = {"*"},
                callback = callback
            })
        end

        -- Tracking Buffers
        local function track(buf) vim.api.nvim_buf_set_var(buf, BUF_TRACKED, true) end

        local function untrack(buf)
            local delete_tracked = function()
                vim.api.nvim_buf_del_var(buf, BUF_TRACKED)
            end
            pcall(delete_tracked)
        end

        local function is_tracked(buf)
            local read_tracked = function()
                vim.api.nvim_buf_get_var(buf, BUF_TRACKED)
            end
            return pcall(read_tracked)
        end

        local function get_tracked_buffers()
            return vim.tbl_filter(function(buf)
                local listed = vim.api.nvim_buf_get_option(buf, "buflisted")
                local tracked = is_tracked(buf)
                return listed and tracked
            end, vim.api.nvim_list_bufs())
        end

        -- Mark for kill
        local kill_buffer = nil

        local mark_for_kill = function(buf) kill_buffer = buf end

        local kill = function()
            if kill_buffer == nil then return end

            vim.api.nvim_buf_delete(kill_buffer, {})
            kill_buffer = nil
        end

        local should_kill = function(buf)
            local hasName = vim.api.nvim_buf_get_name(buf) ~= ""
            local listed = vim.api.nvim_buf_get_option(buf, "buflisted")
            local modified = vim.api.nvim_buf_get_option(buf, "modified")
            local tracked = is_tracked(buf)

            return listed and hasName and not modified and not tracked
        end

        -- Goto
        local function goto_nth_tracked(n)
            return function()
                local tracked_buffers = get_tracked_buffers()
                local buf = tracked_buffers[n]
                if (buf ~= nil) then cmd("b " .. buf)() end
            end
        end

        -- Autocommands
        -- autocmd({"BufWritePost"}, function() track(0) end)

        -- Keymap: ALT+JKL
        vim.keymap.set('n', '∆', goto_nth_tracked(1),
                    {desc = 'Activate Tracked Buffer J'})
        vim.keymap.set('n', '˚', goto_nth_tracked(2),
                    {desc = 'Activate Tracked Buffer K'})
        vim.keymap.set('n', '¬', goto_nth_tracked(3),
                    {desc = 'Activate Tracked Buffer L'})

        -- TODO telescope picker for tracked buffers
        -- TODO binding to close all untracked
        -- TODO heuristic which buffers to keep

        local COLORS = {
            key = "%#lualine_transitional_lualine_a_normal_to_lualine_b_inactive#",
            key_active = "%#lualine_transitional_lualine_a_normal_to_lualine_b_normal#",
            hl = "%#lualine_b_normal#",
            bg = "%#lualine_b_inactive#"
        }

        local function tracked_buffers_lualine()
            local tracked_buffers = get_tracked_buffers()

            local trimmed = {unpack(tracked_buffers, 1, 3)}
            local index_mapping = {'j', 'k', 'l'}

            local pretty = ""
            for index, buf in pairs(trimmed) do
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname == "" then bufname = "No Name" end
                local name = vim.fn.fnamemodify(bufname, ":t")

                local is_current = vim.api.nvim_get_current_buf() == buf
                local is_modified = vim.api.nvim_buf_get_option(buf, "modified")

                local key = is_current and COLORS.key_active or COLORS.key
                key = key .. " " .. index_mapping[index] .. COLORS.bg

                local mod = is_modified and "" or " "
                local display = name .. mod
                if is_current then display = COLORS.hl .. display .. COLORS.bg end

                pretty = pretty .. key .. display
            end

            return "%#lualine_b_inactive#" .. pretty
        end

        vim.keymap.set('n', 'Q',
                    function() print(vim.inspect(tracked_buffers_lualine())) end)

        -- Module
        return {
            tracked_buffers_lualine = tracked_buffers_lualine,
            track = track,
            untrack = untrack,
            is_tracked = is_tracked
        }
    end
}
