local opts = { noremap = true, silent = true }
function keymap(mode, lhs, rhs, desc, group)
    local map_opts = { noremap = true, silent = true }
    if desc and group then
        map_opts.desc = '[' .. group .. '] ' .. desc
    elseif desc then
        map_opts.desc = desc
    end
    vim.keymap.set(mode, lhs, rhs, map_opts)
end

-- space as leader
keymap('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- split navigation
keymap('n', '<C-h>', '<C-w>h', 'Navigate split left', 'splits')
keymap('n', '<C-j>', '<C-w>j', 'Navigate split down', 'splits')
keymap('n', '<C-k>', '<C-w>k', 'Navigate split up', 'splits')
keymap('n', '<C-l>', '<C-w>l', 'Navigate split right', 'splits')

-- split resizing
keymap('n', '<A-h>', ':vertical resize -2<cr>', 'Shrink split left', 'splits')
keymap('n', '<A-j>', ':resize +2<cr>', 'Grow split down', 'splits')
keymap('n', '<A-k>', ':resize -2<cr>', 'Shrink split up', 'splits')
keymap('n', '<A-l>', ':vertical resize +2<cr>', 'Grow split right', 'splits')

-- split equalizing
keymap('n', '<A-=>', ':wincmd =<cr>', 'Equalize splits', 'splits')

-- buffer navigation
keymap('n', '<leader>gb', ':bnext<cr>', 'Next buffer', 'buffers')
keymap('n', '<leader>gB', ':bprev<cr>', 'Previous buffer', 'buffers')

-- stay in indent mode
keymap('v', '<', '<gv', 'Indent left (stay in visual)', 'editing')
keymap('v', '>', '>gv', 'Indent right (stay in visual)', 'editing')

-- move text up and down
keymap('v', '<A-k>', ":m '<-2<cr>gv=gv", 'Move selection up', 'editing')
keymap('v', '<A-j>', ":m '>+1<cr>gv=gv", 'Move selection down', 'editing')

-- when pasting over something, don't replace clipboard
keymap('v', 'p', '"_dP', 'Paste without replacing clipboard', 'editing')

-- copy current file path to clipboard
keymap('n', '<leader>cp', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  print('Copied to clipboard: ' .. path)
end, 'Copy file path to clipboard', 'utils')

-- run task qtest with current file path
keymap('n', '<leader>qt', function()
  local path = vim.fn.expand('%')
  vim.cmd('!task qtest t=' .. path)
end, 'Run qtest on current file', 'utils')

-- :Keybinds command
local function format_lhs(lhs)
    return lhs:gsub(' ', '<leader>')
end

local function parse_group(desc)
    local group, rest = desc:match('^%[(.-)%] (.+)$')
    if group then
        return group, rest
    end
    return 'other', desc
end

vim.api.nvim_create_user_command('Keybinds', function()
    local entries = {}
    local modes = { 'n', 'v', 'i', 't' }
    local mode_names = { n = 'NORMAL', v = 'VISUAL', i = 'INSERT', t = 'TERMINAL' }

    for _, mode in ipairs(modes) do
        local maps = vim.api.nvim_get_keymap(mode)
        for _, map in ipairs(maps) do
            if map.desc and map.desc:match('^%[.-%] ') then
                local group, desc = parse_group(map.desc)
                table.insert(entries, {
                    mode = mode_names[mode] or mode,
                    lhs = format_lhs(map.lhs),
                    desc = desc,
                    group = group,
                })
            end
        end
    end

    -- also grab buffer-local keymaps (LSP-attach, etc.)
    for _, mode in ipairs(modes) do
        local ok, maps = pcall(vim.api.nvim_buf_get_keymap, 0, mode)
        if ok then
            for _, map in ipairs(maps) do
                if map.desc and map.desc:match('^%[.-%] ') then
                    local group, desc = parse_group(map.desc)
                    table.insert(entries, {
                        mode = mode_names[mode] or mode,
                        lhs = format_lhs(map.lhs),
                        desc = desc,
                        group = group .. ' (buffer)',
                    })
                end
            end
        end
    end

    -- group entries by group name
    local groups = {}
    local group_order = {}
    for _, entry in ipairs(entries) do
        if not groups[entry.group] then
            groups[entry.group] = {}
            table.insert(group_order, entry.group)
        end
        table.insert(groups[entry.group], entry)
    end
    table.sort(group_order)

    -- sort entries within each group by mode then key
    for _, group_entries in pairs(groups) do
        table.sort(group_entries, function(a, b)
            if a.mode ~= b.mode then return a.mode < b.mode end
            return a.lhs < b.lhs
        end)
    end

    -- build output
    local output = {}
    for _, group_name in ipairs(group_order) do
        table.insert(output, '')
        table.insert(output, '  [' .. group_name .. ']')
        table.insert(output, '  ' .. string.rep('-', 60))
        for _, entry in ipairs(groups[group_name]) do
            table.insert(output, string.format('  %-10s %-20s %s', entry.mode, entry.lhs, entry.desc))
        end
    end

    -- remove leading blank line
    if #output > 0 and output[1] == '' then
        table.remove(output, 1)
    end

    vim.cmd('botright ' .. math.min(#output + 2, 30) .. 'new')
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].filetype = 'keybinds'
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
end, {})
vim.api.nvim_create_user_command('Keymaps', 'Keybinds', {})
vim.cmd('cabbrev keybinds Keybinds')
vim.cmd('cabbrev keymaps Keybinds')
