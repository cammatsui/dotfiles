return {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        mappings = nil,
    },
    config = function(_, opts)
        require('gitlinker').setup(opts)

        -- <leader>cl: copy permalink to system clipboard (visual selection or current line)
        local cl_opts = { noremap = true, silent = true, desc = 'Copy GitHub permalink' }
        local cl_action = '{ action_callback = function(url) vim.fn.setreg("+", url); print("Copied: " .. url) end }'
        vim.api.nvim_set_keymap('v', '<leader>cl', '<cmd>lua require("gitlinker").get_buf_range_url("v", ' .. cl_action .. ')<cr>', cl_opts)
        vim.api.nvim_set_keymap('n', '<leader>cl', '<cmd>lua require("gitlinker").get_buf_range_url("n", { add_current_line_on_normal_mode = true, action_callback = function(url) vim.fn.setreg("+", url); print("Copied: " .. url) end })<cr>', cl_opts)

        -- parse a github permalink URL into its components
        -- supports: https://github.com/org/repo/blob/{sha}/path/to/file.py#L42-L50
        local function parse_permalink(url)
            local path, sha, line_start, line_end

            -- strip the #L line fragment
            local base, fragment = url:match('^(.-)#?(L.*)$')
            if not fragment or fragment == '' then
                base = url
            end

            -- extract line numbers from fragment
            if fragment and fragment ~= '' then
                line_start, line_end = fragment:match('L(%d+)%-L(%d+)')
                if not line_start then
                    line_start = fragment:match('L(%d+)')
                end
                if line_start then line_start = tonumber(line_start) end
                if line_end then line_end = tonumber(line_end) end
            end

            -- extract sha and path from the URL
            -- pattern: github.com/{org}/{repo}/blob/{sha}/{path}
            sha, path = base:match('/blob/([^/]+)/(.+)$')

            if not path then
                return nil
            end

            return {
                path = path,
                sha = sha,
                line_start = line_start,
                line_end = line_end,
            }
        end

        -- <leader>gl: open local file at permalink's line in a split
        vim.keymap.set('n', '<leader>gl', function()
            local url = vim.fn.input('Permalink: ')
            if url == '' then return end

            local parsed = parse_permalink(url)
            if not parsed then
                print('Could not parse permalink')
                return
            end

            local cmd = 'vsplit ' .. parsed.path
            if parsed.line_start then
                cmd = 'vsplit +' .. parsed.line_start .. ' ' .. parsed.path
            end
            vim.cmd(cmd)

            if parsed.line_start and parsed.line_end then
                vim.cmd('normal! V' .. (parsed.line_end - parsed.line_start) .. 'j')
            end
        end, { desc = 'Open permalink in split (local file)' })

        -- <leader>gp: open exact committed version in a scratch buffer
        vim.keymap.set('n', '<leader>gp', function()
            local url = vim.fn.input('Permalink: ')
            if url == '' then return end

            local parsed = parse_permalink(url)
            if not parsed then
                print('Could not parse permalink')
                return
            end

            local content = vim.fn.systemlist('git show ' .. parsed.sha .. ':' .. parsed.path)
            if vim.v.shell_error ~= 0 then
                print('git show failed — are you in the right repo?')
                return
            end

            vim.cmd('vsplit')
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_win_set_buf(0, buf)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
            vim.bo[buf].buftype = 'nofile'
            vim.bo[buf].modifiable = false
            vim.bo[buf].readonly = true
            vim.api.nvim_buf_set_name(buf, parsed.sha:sub(1, 8) .. ':' .. parsed.path)

            -- set filetype from extension for syntax highlighting
            local ext = parsed.path:match('%.([^%.]+)$')
            if ext then
                vim.filetype.match({ buf = buf, filename = parsed.path })
                local ft = vim.filetype.match({ filename = parsed.path })
                if ft then vim.bo[buf].filetype = ft end
            end

            if parsed.line_start then
                vim.api.nvim_win_set_cursor(0, { parsed.line_start, 0 })
                vim.cmd('normal! zz')
            end
            if parsed.line_start and parsed.line_end then
                vim.cmd('normal! V' .. (parsed.line_end - parsed.line_start) .. 'j')
            end
        end, { desc = 'Open permalink in scratch buffer (exact commit)' })
    end,
}
