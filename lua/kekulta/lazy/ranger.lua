return {
    {
        "kelly-lin/ranger.nvim",
        config = function()
            require("ranger-nvim").setup({ replace_netrw = true })
            vim.api.nvim_set_keymap("n", "<leader>q", "", {
                noremap = true,
                callback = function()
                    vim.cmd("wa")
                    require("ranger-nvim").open(true)
                end,
                desc = "[Q]uit file to File Manager"
            })
        end,
    }
}
