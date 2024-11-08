return {
    "kylechui/nvim-surround",
    config = function()
        require("nvim-surround").setup()

        vim.keymap.set("n", "<Leader>)", "ysiw)", {remap = true})
        vim.keymap.set("n", "<leader>]", "ysiw]", {remap = true})
        vim.keymap.set("n", "<leader>}", "ysiw}", {remap = true})
    end
}
