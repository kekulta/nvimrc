return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },
    {
        "ggandor/leap.nvim",
        name = "leap",
        config = function()
            require("leap").labels = 'sfnjklhodweimbuyvrgtaqpcxzSFNJKLHODWEIMBUYVRGTAQPCXZ'
            require("leap").safe_labels = 'sfnutSFNLHMUGTZ'
            require('leap').opts.safe_labels = {}
            vim.keymap.set('n', 'f', function()
                require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
            end, {desc = "Vim leap"})
        end
    }
}
