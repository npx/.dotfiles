return {
    "numToStr/FTerm.nvim",
    config = function()
        local fterm = require("FTerm")

        fterm.setup({
            border = "rounded",
            dimensions = {
                height = 0.7,
                width = 0.6,
            },
        })

        -- alt-p
        vim.keymap.set("n", "π", fterm.toggle)
        vim.keymap.set("t", "π", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end
}
