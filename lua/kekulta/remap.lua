vim.g.mapleader = " "

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[F]ormat" })

vim.keymap.set({ "n", }, "Q", "@q")
vim.keymap.set({ "n", "v" }, "<S-L>", "$")
vim.keymap.set({ "n", "v" }, "<S-H>", "^")

vim.keymap.set({ "n", }, "<C-k>", "{")
vim.keymap.set({ "n", }, "<C-j>", "}")
vim.keymap.set({ "v", }, "<C-k>", "{")
vim.keymap.set({ "v", }, "<C-j>", "}")

vim.keymap.set({ "n", }, "<C-.>", ":vert res +2<CR>")
vim.keymap.set({ "n", }, "<C-,>", ":vert res -2<CR>")
vim.keymap.set({ "n", }, "<C-=>", ":res +2<CR>")
vim.keymap.set({ "n", }, "<C-->", ":res -2<CR>")

vim.keymap.set({ "t", }, "<Esc>", "<C-\\><C-n>")

vim.api.nvim_create_user_command('Root', 'ProjectRoot', {})
vim.api.nvim_create_user_command('Par', "exec 'cd' . expand('%:p:h')", {})

vim.api.nvim_create_user_command('Dos', "e ++ff=dos", {})
vim.api.nvim_create_user_command('Unix', "e ++ff=unix", {})

vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wa', 'wa', {})
vim.api.nvim_create_user_command('WA', 'wa', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})
