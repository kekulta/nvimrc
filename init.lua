local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 
            "git clone"
            .. "https://github.com/folke/lazy.nvim.git" 
            .. "--branch=stable --filter=blob:none",
            lazypath 
        })
end

vim.opt.rtp:prepend(lazypath) require("lazy").setup({ spec = {
        { "catppuccin/nvim", name = "catppuccin", },
        { 'stevearc/oil.nvim', },
    }, change_detection = { notify = false }
})

-- Setup directory viewer
require("oil").setup({
    columns = { "icon", "permissions", "size", "mtime" },
    constrain_cursor = "name",
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
})

-- Set preferred colorscheme
vim.cmd.colorscheme("catppuccin-macchiato")

-- BINDINGS
-- Execute lua code
vim.keymap.set({"v"}, "<space>x", ":lua<CR>")
vim.keymap.set({"n"}, "<space>x", "V:lua<CR>")

-- Enter Compile mode
vim.keymap.set({"n"}, "<space>c", "q:iComp ")

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<space>-", require("oil").toggle_float)

-- Movement
vim.keymap.set({"n", "v"}, "L", "$")
vim.keymap.set({"n", "v"}, "H", "^")
vim.keymap.set(
    {"n", "v"}, "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set(
    {"n", "v"}, "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- No arrows, please
vim.keymap.set(
    {"n", "i", "v"}, "<Right>", "", { noremap = true, silent = true })
vim.keymap.set(
    {"n", "i", "v"}, "<Left>", "", { noremap = true, silent = true })
vim.keymap.set(
    {"n", "i", "v"}, "<Up>", "", { noremap = true, silent = true })
vim.keymap.set(
    {"n", "i", "v"}, "<Down>", "", { noremap = true, silent = true })

-- Guys, how do I exit terminal in vim?
vim.keymap.set({"t"}, "<Esc>", "<C-\\><C-n>")
vim.keymap.set({"n"}, "<space>st", function() 
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 15)
    vim.cmd.startinsert()
end)

-- Add lox filetype for all *.lox files
vim.filetype.add({ extension = { lox = 'lox', } })

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = "80"

-- Disable linenumbers for built-in terminal
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('SetupTerm', {}),
    pattern = '*',
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('HighlightYank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- COMPILE MODE START
-- Emacs-like compile mode command as lightweight as it gets.

compile_job = nil

function send_to_qflist(_, data, _) 
    for _, s in ipairs(data) do
        local escaped = s:gsub('"', '\\"')
        vim.cmd('caddexpr "' .. escaped .. '"')
    end
end

vim.api.nvim_create_user_command('Comp',
  function(opts)
    vim.cmd('cgetexpr system("echo Compiling...")')
    vim.cmd('copen')

    if compile_job ~= nil then
        vim.fn.jobstop(compile_job)
    end

    compile_job = vim.fn.jobstart(opts.args , {
         on_stdout = send_to_qflist,
         on_stderr = send_to_qflist,
         on_exit = function(_, _, _)
             vim.cmd('caddexpr "' .. 'Compiled!' .. '"') 
         end,
         })
     end,
    { 
      nargs = '+', 
      complete = "shellcmdline",
    }
)

-- COMPILE MODE END
