vim.g.mapleader = " "

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat" })

-- vim.keymap.set("n", "<leader>9", "[(")
-- vim.keymap.set("n", "<leader>0", "])")
-- vim.keymap.set("n", "<leader>[", "[{")
-- vim.keymap.set("n", "<leader>]", "]}")

vim.keymap.set("n", "<C-s>", function()
    vim.cmd("wa")
end)

vim.keymap.set("n", "<CR>", "o<Esc>")
vim.keymap.set("n", "<S-CR>", "O<Esc>")

vim.keymap.set("n", "<S-L>", "$")
vim.keymap.set("n", "<S-H>", "^")
