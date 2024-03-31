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
            severity_sort = false,   -- default to false
        })

        vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open diagnostic [F]loat" })
        vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic issue" })
        vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, { desc = "Go to next deagnostic issue" })
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist, { desc = "Open diagnostic [L]ist" })

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
            { buffer = e.buf, desc = "Go to [D]efinition" })
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = e.buf, desc = "[H]over" })
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
            { buffer = e.buf, desc = "[C]ode [A]ctions" })
        vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end,
            { buffer = e.buf, desc = "[R]eferences" })
        vim.keymap.set("n", "rn", function() vim.lsp.buf.rename() end, { buffer = e.buf, desc = "Re[N]ame" })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
            { buffer = e.buf, desc = "Signature [H]elp" })
    end
})
