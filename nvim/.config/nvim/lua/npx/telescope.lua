local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local actions = require("telescope.actions")

require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "%.mat", "%.meta", "%.asset", "%.prefab", "%.shader", "%.cginc", "%.asmdef", "%.unity" },
    layout_strategy = "vertical"
  },
  mappings = {
    i = {
      ["<C-x>"] = false,
      ["<C-q>"] = actions.send_to_qflist,
    },
  },
}

local M = {}

M.project_files = function()
  local opts = {
	  -- git_command = { "git", "ls-files", "--exclude-standard" } 
	  show_untracked = true
  }
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

M.search_dotfiles = function()
	require("telescope.builtin").git_files({
		prompt_title = "< VimRC >",
		cwd = vim.env.DOTFILES,
		hidden = true,
	})
end

M.git_branches = function()
	require("telescope.builtin").git_branches({
		attach_mappings = function(_, map)
			map("i", "<c-d>", actions.git_delete_branch)
			map("n", "<c-d>", actions.git_delete_branch)
			return true
		end,
	})
end

return M;
