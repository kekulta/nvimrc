vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.o.exrc = true

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 10

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.conceallevel = 1

vim.g.c_syntax_for_h = 1

vim.g.VM_maps = {
    ['Find Under']         = '<C-g>',
    ['Find Subword Under'] = '<C-g>',
    ["Add Cursor Down"]    = '<C-M-j>',
    ["Add Cursor Up"]      = '<C-M-k>',
}
