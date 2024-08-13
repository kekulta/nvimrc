return {
    "nvim-telescope/telescope.nvim",
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find [F]iles" })
        vim.keymap.set("n", "<leader>ts", builtin.lsp_document_symbols, { desc = "Find LSP [S]ymbols" })
        vim.keymap.set('n', '<leader>tg', builtin.live_grep, { desc = 'Search by [G]rep' })
        vim.keymap.set('n', '<leader>tr', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set("n", "<leader>bb", builtin.buffers, { desc = "[B]uffers" })
        vim.keymap.set("n", "<leader>tb", builtin.builtin, { desc = "[T]elescope [B]uiltins" })

        require("telescope").setup({
            defaults = require("telescope.themes").get_dropdown({
                file_sorter = require("telescope.sorters").get_fzy_sorter,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                initial_mode = "normal",
                mappings = {
                    i = {
                        ["<C-y>"] = "select_default",
                        ["<C-h>"] = "which_key",
                    },
                    n = {
                        ["<C-n>"] = "move_selection_next",
                        ["<C-p>"] = "move_selection_previous",
                        ["l"] = "select_default",
                        ["<C-y>"] = "select_default",
                        ["<C-h>"] = "which_key",
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
            pickers = {
                live_grep = {
                    initial_mode = "insert",
                },
                find_files = {
                    initial_mode = "insert",
                },
                buffers = {
                    show_all_buffers = true,
                    sort_mru = true,
                    mappings = {
                        i = {
                            ["<c-d>"] = "delete_buffer",
                        },
                    },
                },
            },
        })
        require("telescope").load_extension("flutter")
        require("telescope").load_extension("fzy_native")
        require("telescope").load_extension("live_grep_args")
        require("telescope").load_extension("ui-select")
        require('telescope').load_extension('projects')
        require('telescope').load_extension('grapple')
    end,
    dependencies = {
        "nvim-telescope/telescope-fzy-native.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",

        "akinsho/flutter-tools.nvim",
        -- Allows using telescope for things like code action (handy for searching)
        "nvim-telescope/telescope-ui-select.nvim",
    },
}
