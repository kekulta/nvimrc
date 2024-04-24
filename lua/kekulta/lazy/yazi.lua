return {
    {
        "SR-MyStar/yazi.nvim",
        name = "yazi",
        opts = {
            -- ...
        },
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>q", "", {
                noremap = true,
                callback = function()
                    vim.cmd("wa")
                    require("yazi").open()
                end,
                desc = "Open file explorer",
            })
        end
    },
    -- {
    --     "kelly-lin/ranger.nvim",
    --     config = function()
    --         require("ranger-nvim").setup({
    --             replace_netrw = true,
    --             ui = {
    --                 height = 0.95,
    --             }
    --         })
    --         vim.api.nvim_set_keymap("n", "<leader>q", "", {
    --             noremap = true,
    --             callback = function()
    --                 vim.cmd("wa")
    --                 require("ranger-nvim").open(true)
    --             end,
    --         })
    --     end,
    -- }
}
