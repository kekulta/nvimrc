return {
    'mfussenegger/nvim-dap',
    name = "dap",
    config = function()
        local dap = require('dap')

        dap.adapters.dart = {
            type = "executable",
            -- As of this writing, this functionality is open for review in https://github.com/flutter/flutter/pull/91802
            command = "flutter",
            args = { "debug_adapter" },
            options = {
                detached = false,
            }
        }
        dap.configurations.dart = {
            {
                type = "dart",
                request = "launch",
                name = "Launch Flutter Program",
                -- The nvim-dap plugin populates this variable with the filename of the current buffer
                program = "${file}",
                -- The nvim-dap plugin populates this variable with the editor's current working directory
                cwd = "${workspaceFolder}",
                -- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
                toolArgs = { "-d", "linux" }
            }
        }


        vim.keymap.set("n", "<leader>dp", function()
            dap.toggle_breakpoint()
        end, { desc = "Toggle break[P]oint" })

        vim.keymap.set("n", "<leader>dr", function()
            dap.repl.toggle()
        end, { desc = "Toggle [R]epl" })

        vim.keymap.set("n", "<leader>dc", function()
            dap.continue()
        end, { desc = "[C]ontinue" })

        vim.keymap.set("n", "<leader>ds", function()
            dap.step_over()
        end, { desc = "[S]tep over" })

        vim.keymap.set("n", "<leader>di", function()
            dap.step_into()
        end, { desc = "Step [I]nto" })

        vim.keymap.set("n", "<leader>do", function()
            dap.step_out()
        end, { desc = "Step [O]ut" })

        vim.keymap.set("n", "<leader>dt", function()
            dap.terminate()
        end, { desc = "[T]erminate" })
    end
}
