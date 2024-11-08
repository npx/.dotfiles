return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local mason = require("npx.mason-setup")

        mason.configure("pylsp", {
            settings = {
                pylsp = {
                    plugins = {
                        pycodestyle = {ignore = {}, maxLineLength = 100},
                        rope_autoimport = {enabled = true},
                        rope_completion = {enabled = true}
                    }
                }
            }
        })

        -- borders for hover
        vim.lsp.handlers["textDocument/hover"] =
            vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

        -- ESLint
        mason.configure("eslint", {
            filetypes = {
                'javascript', 'javascriptreact', 'javascript.jsx', 'typescript',
                'typescriptreact', 'typescript.tsx', 'vue', 'svelte', 'astro', 'html'
            },
            on_new_config = function(config, new_root_dir)
                -- The "workspaceFolder" is a VSCode concept. It limits how far the
                -- server will traverse the file system when locating the ESLint config
                -- file (e.g., .eslintrc).

                config.settings.workspaceFolder = {
                    uri = vim.loop.cwd(),
                    name = vim.fn.fnamemodify(new_root_dir, ":t")
                }
            end
        })

        mason.configure("theme_check", {root_dir = function() return vim.loop.cwd() end})

        mason.configure("angularls", {
            on_attach = function(client)
                vim.cmd [[compiler angular]]
                client.server_capabilities.renameProvider = false
            end
        })

        -- TypeScript
        local init_options = require("nvim-lsp-ts-utils").init_options;
        init_options['preferences']['organizeImportsIgnoreCase'] = true;
        init_options['preferences']['importModuleSpecifierPreference'] = "relative";

        mason.configure("tsserver", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol
                                                                        .make_client_capabilities()),
            -- Needed for inlayHints. Merge this table with your settings or copy
            -- it from the source if you want to add your own init_options.
            init_options = init_options,
            --
            on_attach = function(client, bufnr)
                local ts_utils = require("nvim-lsp-ts-utils")

                -- defaults
                ts_utils.setup({
                    debug = false,
                    disable_commands = false,
                    enable_import_on_completion = true,
                    -- import all
                    import_all_timeout = 5000, -- ms
                    -- lower numbers = higher priority
                    import_all_priorities = {
                        same_file = 1, -- add to existing import statement
                        local_files = 2, -- git files or files with relative path markers
                        buffer_content = 3, -- loaded buffer content
                        buffers = 4 -- loaded buffer names
                    },
                    import_all_scan_buffers = 100,
                    import_all_select_source = false,
                    -- if false will avoid organizing imports
                    always_organize_imports = true,
                    -- filter diagnostics
                    filter_out_diagnostics_by_severity = {},
                    filter_out_diagnostics_by_code = {},
                    -- inlay hints
                    auto_inlay_hints = false,
                    inlay_hints_highlight = "Comment",
                    inlay_hints_priority = 200, -- priority of the hint extmarks
                    inlay_hints_throttle = 150, -- throttle the inlay hint request
                    inlay_hints_format = {
                        -- format options for individual hint kind
                        Type = {},
                        Parameter = {},
                        Enum = {}
                        -- Example format customization for `Type` kind:
                        -- Type = {
                        --     highlight = "Comment",
                        --     text = function(text)
                        --         return "->" .. text:sub(2)
                        --     end,
                        -- },
                    },
                    -- update imports on file move
                    update_imports_on_move = false,
                    require_confirmation_on_move = false,
                    watch_dir = nil
                })

                -- required to fix code action ranges and filter diagnostics
                ts_utils.setup_client(client)

                -- no default maps, so you may want to define some here
                local opts = {silent = true}
                vim.api
                    .nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>",
                                            opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>",
                                            opts)
            end
        })

        -- C# (Omnisharp)
        local pid = vim.fn.getpid()
        local omnisharp_bin = "/Users/ybaron/omnisharp/run"
        mason.configure("omnisharp", {
            cmd = {omnisharp_bin, "--languageserver", "--hostPID", tostring(pid)},
            root_dir = require("lspconfig").util.root_pattern("*.csproj", "*.sln"),
            capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol
                                                                        .make_client_capabilities())
        })

        -- Lua
        mason.configure("lua_ls",
                        {settings = {Lua = {diagnostics = {globals = {"vim"}}}}})

        -- auto setup the rest
        mason.setup()
    end
}
