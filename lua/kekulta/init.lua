require("kekulta.set")
require("kekulta.remap")
require("kekulta.lazy_init")

local augroup = vim.api.nvim_create_augroup
local kekultagroup = augroup('kekulta', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})


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
    group = kekultagroup,
    callback = function(e)
        local opts = { buffer = e.buf }

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
            severity_sort = false,    -- default to false
        })

        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist)

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})
