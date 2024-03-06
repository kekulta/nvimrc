return {
    {
        'numToStr/Comment.nvim',
        name = "Comment",
        config = function()
            require('Comment').setup()
        end,
        lazy = false,
    }
}
