return {
    {
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()

            require('which-key').register {
                ['<leader>d'] = { name = '[D]ebug and [D]iagnostics', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[T]elescope', _ = 'which_key_ignore' },
                ['<leader>c'] = { name = '[C]ode actions', _ = 'which_key_ignore' },
            }
        end,
    }
}
