return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope_builtin = require("telescope.builtin")
        local actions = require("telescope.actions")

        require("telescope").setup({
            defaults = {
                file_ignore_patterns = {
                    ".git/", "backendApi/", "backend/", -- make this load via exrc to project local
                    "apis/", -- make this load via exrc to project local
                    "%.mat", "%.meta", "%.asset", "%.prefab", "%.shader", "%.cginc",
                    "%.asmdef", "%.unity", "node_modules/", "projects/api/"
                },
                layout_strategy = "vertical",
                mappings = {
                    i = {["<Tab>"] = "select_vertical", ["<esc>"] = actions.close},
                    n = {["<Tab>"] = "select_vertical"}
                }
            }
        })

        local M = {}

        M.project_files = function()
            local opts = {use_git_root = false, show_untracked = true}
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

        return M
    end
}
