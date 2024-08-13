return {
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                manual_mode = true,
            }

            vim.keymap.set("n", "<leader>r", function()
                require 'telescope'.extensions.projects.projects {}
            end, { desc = "Set [R]oot" })
        end
    },
}
