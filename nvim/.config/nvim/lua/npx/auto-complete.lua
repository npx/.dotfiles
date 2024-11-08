return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                expand = function(args)
                    -- For `vsnip` user.
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
            mapping = {
                ["<Tab>"] = cmp.mapping.select_next_item({
                    behavior = cmp.SelectBehavior.Replace
                }),
                ["<Down>"] = cmp.mapping.select_next_item({
                    behavior = cmp.SelectBehavior.Select
                }),
                ["<Up>"] = cmp.mapping.select_prev_item({
                    behavior = cmp.SelectBehavior.Select
                }),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                })
            },
            sources = {
                {name = "nvim_lsp", max_item_count = 10},
                {name = "vsnip", max_item_count = 10},
                {name = "buffer", keyword_length = 5, max_item_count = 10}
            },
            window = {
                completion = {border = "rounded", scrollbar = "║"},
                documentation = {border = "rounded", scrollbar = ""}
            }
        })
    end
}
