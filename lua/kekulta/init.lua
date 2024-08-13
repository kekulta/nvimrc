require("kekulta.set")
require("kekulta.remap")
require("kekulta.lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local lsp_group = augroup('Lsp', {})
local yank_group = augroup('HighlightYank', {})
local qf_group = augroup('QuickFix', {})
local flutter_group = augroup('FLutter', {})
local c_group = augroup('C', {})

autocmd('FileType', {
    pattern = 'c',
    group = c_group,
    callback = function()
        vim.keymap.set("n", "gh", ":ClangdSwitchSourceHeader<CR>",
            { desc = "Flutter tools", silent = true, buffer = true })
    end,
})

autocmd('FileType', {
    pattern = 'dart',
    group = flutter_group,
    callback = function()
        vim.keymap.set("n", "<leader>tt", function()
            require('telescope').extensions.flutter.commands()
        end, { desc = "Flutter tools", buffer = true })
    end,
})

autocmd('FileType', {
    pattern = 'qf',
    group = qf_group,
    callback = function()
        vim.keymap.set({ 'n' }, "j", "j<CR><C-w>p", { noremap = true, silent = true, buffer = true })
        vim.keymap.set({ 'n' }, "k", "k<CR><C-w>p", { noremap = true, silent = true, buffer = true })
    end,
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd('LspAttach', {
    group = lsp_group,
    callback = function(e)
        vim.diagnostic.config({
            underline = true,
            signs = true,
            virtual_text = false,
            float = {
                show_header = true,
                source = 'if_many',
                border = 'rounded',
                focusable = false,
            },
            update_in_insert = true, -- default to false
            severity_sort = false,   -- default to false
        })

        local telescope = require('telescope.builtin')

        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open diagnostic [F]loat" })
        vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic issue" })
        vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, { desc = "Go to next deagnostic issue" })
        vim.keymap.set("n", "<leader>dl", telescope.diagnostics, { desc = "Open diagnostic [L]ist" })

        vim.keymap.set("n", "gd", function() telescope.lsp_definitions() end,
            { buffer = e.buf, desc = "Go to [D]efinition" })
        vim.keymap.set("n", "gr", function() telescope.lsp_references() end,
            { buffer = e.buf, desc = "[R]eferences" })

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = e.buf, desc = "[H]over" })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
            { buffer = e.buf, desc = "Signature [H]elp" })
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
            { buffer = e.buf, desc = "[C]ode [A]ctions" })
        vim.keymap.set("n", "rn", function() vim.lsp.buf.rename() end, { buffer = e.buf, desc = "Re[N]ame" })
    end
})
