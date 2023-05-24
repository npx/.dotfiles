-- Const
--
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

-- Autocommands
autocmd({"BufWritePost"}, function() track(0) end)

-- Keymap: ALT+JK
vim.keymap.set('n', '∆', cmd("bp"), {desc = 'Buffer Previous'})
vim.keymap.set('n', '˚', cmd("bn"), {desc = 'Buffer Next'})

local tracked_buffers = function()
    local current_buffer = vim.api.nvim_get_current_buf()

    local tracked_buffers = vim.tbl_filter(function(buf)
        local listed = vim.api.nvim_buf_get_option(buf, "buflisted")
        local tracked = is_tracked(buf)
        return listed and (tracked or buf == current_buffer)
    end, vim.api.nvim_list_bufs())

    local trimmed = {unpack(tracked_buffers, 1, 3)}

    local decorated = vim.tbl_map(function(buf)
        local bufname = vim.api.nvim_buf_get_name(buf)
        if bufname == "" then bufname = "No Name" end
        local name = vim.fn.fnamemodify(bufname, ":t")

        local mod = vim.api.nvim_buf_get_option(buf, "modified") and "*" or " "
        local display = name .. mod

        local tracked = is_tracked(buf)
        if tracked then
            display = " " .. display .. " "
        else
            display = "(" .. display .. ")"
        end

        local is_current = vim.api.nvim_get_current_buf() == buf
        if is_current then
            local hl_pre = "%#lualine_c_inactive#"
            local hl_post = "%#lualine_c_normal#"

            display = hl_pre .. display .. hl_post
        end

        return display
    end, trimmed)

    local pretty = table.concat(decorated, '')
    return pretty
end

vim.keymap.set('n', 'Q', function() print(vim.inspect(tracked_buffers())) end)

-- Module
return {tracked_buffers = tracked_buffers}

