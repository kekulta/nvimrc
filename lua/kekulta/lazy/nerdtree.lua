return {
    {
        "preservim/nerdtree",
        name = "nerdtree",
        config = function()
            -- require("leap").NERDTreeFileLines = 1
            -- require("leap").NERDTreeHijackNetrw = 0
            vim.keymap.set('n', '<leader>n', ':NERDTreeFocus<CR>', { desc = "Vim leap" })
            vim.keymap.set('n', '<C-n>', ':NERDTree<CR>', { desc = "Vim leap" })
            vim.keymap.set('n', '<C-t>', ':NERDTreeToggle<CR>', { desc = "Vim leap" })
            vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>', { desc = "Vim leap" })
        end
    }
}
