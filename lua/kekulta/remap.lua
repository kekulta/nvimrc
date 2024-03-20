vim.g.mapleader = " "

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat" })

-- vim.keymap.set("n", "<leader>9", "[(")
-- vim.keymap.set("n", "<leader>0", "])")
-- vim.keymap.set("n", "<leader>[", "[{")
-- vim.keymap.set("n", "<leader>]", "]}")

vim.keymap.set("n", "<C-s>", function()
    vim.cmd("wa")
end, {desc = "[S]ave file"})

vim.keymap.set({ "n", "v" }, "<S-L>", "$")
vim.keymap.set({ "n", "v" }, "<S-H>", "^")

