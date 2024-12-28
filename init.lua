local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git clone https://github.com/folke/lazy.nvim.git --branch=stable --filter=blob:none", lazypath })
end

vim.opt.rtp:prepend(lazypath) require("lazy").setup({ spec = {
        { "catppuccin/nvim", name = "catppuccin", },
        { 'stevearc/oil.nvim', },
        { "gelguy/wilder.nvim", dependencies = { "nixprime/cpsm" }},
    }, change_detection = { notify = false }
})
--
-- local wilder = require("wilder")
--
-- wilder.setup({
--     modes = {':', '/', '?'},
-- })
--
-- wilder.set_option('pipeline', {
--   wilder.branch(
--     wilder.python_file_finder_pipeline({
--       file_command = function(ctx, arg)
--         if string.find(arg, '.') ~= nil then
--           return {'fd', '-tf', '-H'}
--         else
--           return {'fd', '-tf'}
--         end
--       end,
--       dir_command = {'fd', '-td'},
--     }),
--     wilder.cmdline_pipeline({
--       fuzzy = 2,
--       set_pcre2_pattern = 1,
--     }),
--     wilder.python_search_pipeline({
--       pattern = 'fuzzy',
--     })
--   ),
-- })

-- WILDEST START
-- Scratch for my completion plugin.
-- It doesn't work right now, I'm hust experementing with it.

local completions = {}
local wildest = vim.api.nvim_create_augroup('Wildest', {})
local aucmd = vim.api.nvim_create_autocmd
local del_aucmd = vim.api.nvim_del_autocmd
local outputtmpname = vim.fn.tempname()

local function renderline(results)
    local width = vim.fn.winwidth(0)
    local index, size, len = 1, 0, 0

    for key, value in pairs(results) do
        len = string.len(value)
        if (size + 4 + len + (index - 1) * 2 <= width) then 
            index = index + 1
            size = size + len
        else 
            break
        end
    end
    local new_line = '{ ' .. table.concat(results, ', ', 1, index - 1) .. ' }' .. '|' .. table.getn(results)
    new_line = new_line:gsub('%%', '%%%%')
    print(new_line)
    vim.fn.setwinvar(0, '&statusline', new_line)
    vim.cmd.redrawstatus()
end

local status = nil
local onChange = nil
local completion_job = nil

aucmd({"CmdlineLeave"}, {
    group = wildest,
    callback = function(ev)
        vim.fn.setwinvar(0, '&statusline', status)
        del_aucmd(onChange)
    end
})

aucmd({"CmdlineEnter"}, {
    group = wildest,
    callback = function(ev)
        status = vim.fn.getwinvar(0, '&statusline')
        onChange = aucmd({'CmdlineChanged'}, {
        group = wildest,
        callback = function(ev)
            if completion_job ~= nil then
                vim.fn.jobstop(completion_job)
            end

            local cmd = vim.fn.getcmdline()
            local type = vim.fn.getcmdcompltype()
            local pat = vim.fn.getcmdcomplpat()
            local fuzzychar = ''

            if (pat ~= '') then
                fuzzychar = pat:sub(1, 1) 
            end

            if (type == '') then 
            else
                if (type == 'shellcmd') then
                    if (fuzzychar ~= '') then
                        renderline(vim.fn.getcompletion(fuzzychar, 'shellcmd'))
                    else
                        renderline({})
                    end
                elseif(type == 'file') then
                    local cmd_fzf = {'sh', '-c', 'fd -tf | fzf -f "' .. pat .. '"' .. ' | head ' .. ' > ' .. outputtmpname}

                    completion_job = vim.fn.jobstart(cmd_fzf, { on_exit = function(_, _, _) 
                        local output = {}

                        local f = io.open(outputtmpname)
                        if f then
                          output = vim.split(f:read("*a"), "\n")
                          f:close()
                        end

                        renderline(output)
                        vim.fn.delete(outputtmpname)
                    end }) 
                else
                    local comp = vim.fn.getcompletion(fuzzychar, type)
                    renderline(comp)
                end
            end
            end
        })
    end
})

-- WILDEST END

require("oil").setup({
    columns = { "icon", "permissions", "size", "mtime" },
    constrain_cursor = "name",
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<space>-", require("oil").toggle_float)

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

vim.keymap.set({"n", "v"}, "L", "$")
vim.keymap.set({"n", "v"}, "H", "^")
vim.keymap.set({"t"}, "<Esc>", "<C-\\><C-n>")

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
         on_exit = function(_, _, _) vim.cmd('caddexpr "' .. 'Compiled!' .. '"') end,
         })
     end,
    { 
      nargs = '+', 

      -- Workaround for completion if your nvim doesn't have 
      -- https://github.com/neovim/neovim/issues/30699 merged.
      -- Probably gonna break a few completion plugins.
      --
	  -- complete = function(_, cmdline)
	  -- 	local cmd = cmdline:gsub("Comp%s+", "")
	  -- 	local results = vim.fn.getcompletion(("!%s"):format(cmd), "cmdline")
	  -- 	return results
	  -- end,

      complete = "shellcmdline",
    }
)

-- COMPILE MODE END
