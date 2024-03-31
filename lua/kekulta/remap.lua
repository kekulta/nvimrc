vim.g.mapleader = " "

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat" })

vim.keymap.set("n", "<C-s>", function()
    vim.cmd("wa")
end, { desc = "[S]ave file" })

vim.keymap.set({ "n", }, "Q", "@q")
vim.keymap.set({ "n", "v" }, "<S-L>", "$")
vim.keymap.set({ "n", "v" }, "<S-H>", "^")
vim.keymap.set({ "n", }, "<C-k>", "[m")
vim.keymap.set({ "n", }, "<C-j>", "]m")
vim.keymap.set({ "n", }, "<A-k>", ":m-2<CR>")
vim.keymap.set({ "n", }, "<A-j>", ":m+<CR>")

vim.keymap.set({ "n", }, "<C-.>", ":vert res +2<CR>")
vim.keymap.set({ "n", }, "<C-,>", ":vert res -2<CR>")
vim.keymap.set({ "n", }, "<C-=>", ":res +2<CR>")
vim.keymap.set({ "n", }, "<C-->", ":res -2<CR>")
vim.keymap.set({ "n", }, "T", "<C-w>t")
