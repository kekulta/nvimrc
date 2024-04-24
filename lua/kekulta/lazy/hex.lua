return {
    {
        'RaafatTurki/hex.nvim',
        config = function()
            require 'hex'.setup()

            vim.keymap.set('n', '<leader>x', ':HexToggle<CR>', { desc = "Toggle Hex view" })
        end
    }
}
