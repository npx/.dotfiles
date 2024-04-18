local bm = require("npx.buffer-management")
local arena = require("arena")

arena.setup({
    max_items = nil,

    keybinds = {
        ["p"] = arena.action(function(bufnr)
            if (bm.is_tracked(bufnr)) then
                bm.untrack(bufnr)
            else
                bm.track(bufnr)
            end

            arena.pin(bufnr)
        end)
    }
});

vim.keymap.set('n', '…', "<cmd>ArenaToggle<cr>", {desc = 'ToggleArena'})
