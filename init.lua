local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 
            "git clone"
            .. "https://github.com/folke/lazy.nvim.git" 
            .. "--branch=stable --filter=blob:none",
            lazypath 
        })
end

vim.opt.rtp:prepend(lazypath) require("lazy").setup({
    spec = {
        { "catppuccin/nvim", name = "catppuccin", },
        { 'stevearc/oil.nvim', },
        {
          'Wansmer/langmapper.nvim',
          lazy = false,
          priority = 1, -- High priority is needed if you will use `autoremap()`
          config = function()
          end,
        },
        {
            "mason-org/mason.nvim",
            opts = {}
        },
    },
    -- Do not autoreload ui
    change_detection = { notify = false },
    -- Disable path reset. Would fail without tressitter otherwise.
    performance = { rtp = { reset = false } }
})

-- Setup language map for cyrillic, p. 1
local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
    -- | `to` should be first     | `from` should be second
    escape(ru_shift) .. ';' .. escape(en_shift),
    escape(ru) .. ';' .. escape(en),
}, ',')

require('langmapper').setup({})

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
vim.keymap.set("n", "`", ":cd %:h<CR>:pwd<CR>")

-- Selection
vim.keymap.set({"v"}, "<", "<gv", { noremap = true, silent = true })

-- Movement
vim.keymap.set({"n", "v"}, "L", "$")
vim.keymap.set({"n", "v"}, "H", "^")
vim.keymap.set(
    {"n", "v"}, "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set(
    {"n", "v"}, "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true})

---- No arrows, please
--- We like arrows actually
-- vim.keymap.set(
--     {"n", "i", "v"}, "<Right>", "", { noremap = true, silent = true })
-- vim.keymap.set(
--     {"n", "i", "v"}, "<Left>", "", { noremap = true, silent = true })
-- vim.keymap.set(
--     {"n", "i", "v"}, "<Up>", "", { noremap = true, silent = true })
-- vim.keymap.set(
--     {"n", "i", "v"}, "<Down>", "", { noremap = true, silent = true })

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

-- Add error format and commentstring for the F#
vim.cmd("set errorformat+=%min\\ %f:line\\ %l")
vim.cmd("set errorformat+=%f(%l\\\\,%c):\\ %t%m")
vim.api.nvim_create_autocmd( { "BufNewFile", "BufRead", },
    {
        pattern = "*.fs",
        callback = function()
            vim.cmd("set commentstring=(*\\ %s\\ *)")
        end
    }
)

-- Add commentstring for scad
vim.api.nvim_create_autocmd( { "BufNewFile", "BufRead", },
    {
        pattern = "*.scad",
        callback = function()
            vim.cmd("set commentstring=//\\ %s")
        end
    }
)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = "80"
vim.opt.wildmenu = false
vim.opt.path = '.,/usr/local/include,/usr/include,/usr/avr/include'

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

-- COLORIZE MODE START
function ansi_colorize()
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.opt.listchars = { space = " " }

  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))
  vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
  -- vim.api.nvim_create_autocmd("TextChanged", { buffer = buf, command = "normal! G$" })
  -- vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
end
-- COLORIZE MODE END

-- Setup language map for cyrillic, p. 2
require('langmapper').automapping({ global = true, buffer = true })
