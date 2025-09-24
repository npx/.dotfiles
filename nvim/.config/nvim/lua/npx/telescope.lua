local telescope_builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            ".git/", "backendApi/", "backend/", -- make this load via exrc to project local
            "apis/",                            -- make this load via exrc to project local
            "%.mat", "%.meta", "%.asset", "%.prefab", "%.shader", "%.cginc",
            "%.asmdef", "%.unity", "node_modules/", "projects/api/"
        },
        layout_strategy = "vertical",
        mappings = {
            i = { ["<Tab>"] = "select_vertical", ["<esc>"] = actions.close },
            n = { ["<Tab>"] = "select_vertical" }
        }
    }
})

local M = {}

M.project_files = function()
    local opts = { use_git_root = false, show_untracked = true }
    local ok = pcall(telescope_builtin.git_files, opts)
    if not ok then telescope_builtin.find_files(opts) end
end

M.search_dotfiles = function()
    telescope_builtin.git_files({
        prompt_title = "< VimRC >",
        cwd = vim.env.DOTFILES,
        hidden = true
    })
end

M.git_branches = function()
    telescope_builtin.git_branches({
        attach_mappings = function(_, map)
            map("i", "<c-d>", actions.git_delete_branch)
            map("n", "<c-d>", actions.git_delete_branch)
            return true
        end
    })
end

M.setup_keybindings = function()
    vim.keymap.set('n', '<C-p>', function()
        M.project_files()
    end, { silent = true })

    vim.keymap.set('n', '<leader>ff', function()
        telescope_builtin.find_files({ hidden = true })
    end, { silent = true })

    vim.keymap.set('n', '<leader>fg', function()
        telescope_builtin.live_grep({
            glob_pattern = {"!package-lock.json", "!lazy-lock.json"},
            additional_args = { "--hidden" }
        })
    end, { silent = true, desc = "Live grep" })

    vim.keymap.set('n', '<leader>gb', function()
        M.git_branches()
    end, { silent = true })

    vim.keymap.set('n', '<leader>ds', function()
        telescope_builtin.lsp_document_symbols()
    end, { silent = true })

    vim.keymap.set('n', '<leader>ws', function()
        telescope_builtin.lsp_dynamic_workspace_symbols()
    end, { silent = true })

    vim.keymap.set('n', '<leader>vrc', function()
        M.search_dotfiles()
    end, { silent = true })
end

-- Set up keybindings after telescope is configured
M.setup_keybindings()

return M
