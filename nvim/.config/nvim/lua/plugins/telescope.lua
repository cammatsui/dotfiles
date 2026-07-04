return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')

        keymap('n', '<leader>ff', builtin.find_files, 'Find files', 'telescope')
        keymap('n', '<leader>fgf', builtin.git_files, 'Find git files', 'telescope')
        keymap('n', '<leader>fr', function()
            builtin.grep_string({ search = vim.fn.input('grep > ') })
        end, 'Grep string (fixed)', 'telescope')
        keymap('n', '<leader>fg', builtin.live_grep, 'Live grep', 'telescope')
    end
}
