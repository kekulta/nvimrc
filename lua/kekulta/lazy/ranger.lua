return {
    {
        "kelly-lin/ranger.nvim",
        config = function()
            require("ranger-nvim").setup({
                replace_netrw = true,
                ui = {
                    height = 0.95,
                }
            })
            vim.api.nvim_set_keymap("n", "<leader>q", "", {
                noremap = true,
                callback = function()
                    vim.cmd("wa")
                    require("ranger-nvim").open(true)
                end,
            })
        end,
    }
}
