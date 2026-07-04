return {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
        open_mapping = [[<C-\>]],
        winbar = { enabled = false },
    },
    config = function(_, opts)
        require('toggleterm').setup(opts)

        keymap('t', '<esc>', '<C-\\><C-n>', 'Exit terminal mode', 'toggleterm')
        keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', 'Navigate up from terminal', 'toggleterm')
    end,
}
