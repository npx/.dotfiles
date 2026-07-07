-- Claude Code IDE integration (coder/claudecode.nvim).
-- Runs a WebSocket "IDE" server inside Neovim (auto_start) that writes
-- ~/.claude/ide/<port>.lock. An external `claude` connects to it for editor
-- features: send selections/buffers as context, review edits as native diffs.
--
-- We run claude OUTSIDE Neovim in a tmux split (provider = "external").

-- Flag toggled by the open keymaps and read by external_terminal_cmd below,
-- deciding whether the new tmux pane grabs focus (default) or not (`-d`).
local claude = { keep_focus = false }

local claudecode = require("claudecode")

claudecode.setup({
  auto_start = true, -- start WS server + write lockfile on Neovim launch
  terminal = {
    provider = "external",
    provider_opts = {
      -- Called with (claude_cmd, env). `env` carries CLAUDE_CODE_SSE_PORT,
      -- ENABLE_IDE_INTEGRATION, FORCE_CODE_TERMINAL, no_proxy/NO_PROXY.
      -- Return argv; the plugin runs it via jobstart. Pass env through tmux
      -- `-e` so it reaches the new pane's shell (the tmux server owns that
      -- shell, so process-inherited env would NOT reach it). This makes the
      -- external claude auto-connect to this Neovim — no manual `/ide`.
      external_terminal_cmd = function(cmd, env)
        -- `-h` with no `-l` splits the current pane 50/50 (tmux default width).
        local args = { "tmux", "split-window", "-h", "-c", vim.fn.getcwd() }
        if claude.keep_focus then
          table.insert(args, "-d") -- open the split but leave focus in Neovim
        end
        for k, v in pairs(env or {}) do
          table.insert(args, "-e")
          table.insert(args, k .. "=" .. tostring(v))
        end
        -- Start claude in ultracode effort. Single-quote the JSON so tmux's
        -- `sh -c` passes it to claude intact.
        table.insert(args, cmd .. [[ --settings '{"ultracode": true}']])
        return args
      end,
    },
  },
})

local function open(keep_focus)
  -- Already connected? Detached tmux splits aren't tracked by the plugin, so
  -- :ClaudeCode would open a second pane. Instead hop to the existing one — it's
  -- always the `-h` split to our right (see external_terminal_cmd above).
  if claudecode.is_claude_connected() then
    if not keep_focus then
      vim.fn.system({ "tmux", "select-pane", "-R" })
    end
    return
  end
  claude.keep_focus = keep_focus
  vim.cmd("ClaudeCode")
end

local map = vim.keymap.set
map("n", "<leader>ac", function() open(false) end, { desc = "Claude: open split (focus claude)" })
map("n", "<leader>aC", function() open(true) end,  { desc = "Claude: open split (keep focus in nvim)" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>",       { desc = "Claude: send selection" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",      { desc = "Claude: add current buffer" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   { desc = "Claude: deny diff" })
