return {
    'MagicDuck/grug-far.nvim',
    opts = {},
    config = function(_, opts)
        require('grug-far').setup(opts)

        keymap('n', '<leader>fs', function()
            require('grug-far').open()
        end)
        keymap('n', '<leader>fw', function()
            require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
        end)
    end,
}
