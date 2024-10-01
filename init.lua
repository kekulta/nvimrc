local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git clone https://github.com/folke/lazy.nvim.git --branch=stable --filter=blob:none", lazypath })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { 'stevearc/oil.nvim', },
        { "catppuccin/nvim", name = "catppuccin", },
    },
    change_detection = { notify = false }
})

require("oil").setup({
    columns = { "icon", "permissions", "size", "mtime" },
    constrain_cursor = "name",
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.cmd.colorscheme("catppuccin-macchiato")

local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.keymap.set({"t"}, "<Esc>", "<C-\\><C-n>")

function send_to_qflist(_, data, _) 
    for _, s in ipairs(data) do
        local escaped = s:gsub('"', '\\"')
        vim.cmd('caddexpr "' .. escaped .. '"')
        print(s)
    end
end

compile_job = nil

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
         on_exit = function(_, _, _) vim.cmd('caddexpr "' .. 'Compiled!' .. '"') end,
         })
     end,
  
  { nargs = 1, 
  complete = function(_, cmdline)
		local cmd = cmdline:gsub("Comp%s+", "")
		local results = vim.fn.getcompletion(("!%s"):format(cmd), "cmdline")
		return results
	end,
})
