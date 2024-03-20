return {
    "nvim-telescope/telescope.nvim",
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>ts", builtin.lsp_document_symbols, { desc = "Find LSP [S]ymbols" })
        vim.keymap.set("n", "<leader>tt", function()
            require('telescope').extensions.flutter.commands()
        end, { desc = "Flutter tools" })

        vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Find [F]iles" })
        vim.keymap.set('n', '<leader>tg', builtin.live_grep, { desc = 'Search by [G]rep' })
        vim.keymap.set('n', '<leader><leader>', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

        require("telescope").setup({
            defaults = require("telescope.themes").get_dropdown({
                file_sorter = require("telescope.sorters").get_fzy_sorter,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                mappings = {
                    i = {
                        ["<C-x>"] = false,
                    },
                },
            }),
            extensions = {
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
                ["ui-select"] = {
                    specific_opts = {
                        codeactions = false,
                    },
                },
            },
        })
        require("telescope").load_extension("flutter")
        require("telescope").load_extension("fzy_native")
        require("telescope").load_extension("live_grep_args")
        require("telescope").load_extension("ui-select")
    end,
    dependencies = {
        "nvim-telescope/telescope-fzy-native.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",

        "akinsho/flutter-tools.nvim",
        -- Allows using telescope for things like code action (handy for searching)
        "nvim-telescope/telescope-ui-select.nvim",
    },
}
