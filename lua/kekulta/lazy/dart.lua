return {
    {
        "dart-lang/dart-vim-plugin"
    },
    {
        "akinsho/flutter-tools.nvim",
        name = "flutter-tools",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = function()
            require("flutter-tools").setup {
                widget_guides = {
                    enabled = true,
                },
                closing_tags = {
                    prefix = "//", -- character to use for close tag e.g. > Widget
                    enabled = true -- set to false to disable
                },
                settings = {
                    showTodos = true,
                    completeFunctionCalls = true,
                    renameFilesWithClasses = "prompt", -- "always"
                    enableSnippets = true,
                    updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
                }
            }
        end
    }
}
