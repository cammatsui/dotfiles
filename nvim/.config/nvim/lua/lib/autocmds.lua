-- :help autocmd

-- equalize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- prek
local VENV_COMMAND = "PATH=.venv/bin:$PATH prek run --hook-stage manual --files "
local UV_COMMAND = "uv run prek run --files "
local PNPM_BIOME_COMMAND = "pnpm exec biome check --fix --no-errors-on-unmatched "

local pre_commit_configs = {
    {
        repo = "mbe",
        extensions = { "py", "graphql" },
        command = VENV_COMMAND,
    },
    {
        repo = "dotfiles",
        extensions = { "lua" },
        command = VENV_COMMAND,
    },
    {
        repo = "dagster-workflows-core",
        extensions = { "py", "yaml", "yml" },
        command = UV_COMMAND,
    },
    {
        repo = "admin3",
        extensions = { "ts", "tsx", "js", "jsx", "mjs", "cjs", "json", "jsonc", "css" },
        command = PNPM_BIOME_COMMAND,
    },
}

local function run_pre_commit(config)
    local command = config.command .. vim.fn.expand('%:p')
    vim.fn.jobstart(command, {
        on_exit = function(_, exit_code)
            vim.api.nvim_command('checktime')
        end,
    })
end

local auto_pre_commit_group = vim.api.nvim_create_augroup("AutoPreCommit", { clear = true })

local function setup_pre_commit(config)
    if vim.fn.getcwd():find(config.repo, 1, true) == nil then
        return
    end

    local pattern = {}
    for _, ext in ipairs(config.extensions) do
        table.insert(pattern, "*." .. ext)
    end
    local pattern_string = table.concat(pattern, ",")

    vim.api.nvim_create_autocmd("BufWritePost", {
        group = auto_pre_commit_group,
        pattern = pattern_string,
        callback = function()
            run_pre_commit(config)
        end,
    })
end

for _, pre_commit_config in ipairs(pre_commit_configs) do
    setup_pre_commit(pre_commit_config)
end

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "[lsp] " .. desc })
        end

        map("K", vim.lsp.buf.hover, "Hover Documentation")
        map("gd", vim.lsp.buf.definition, "Goto Definition")
        map("gr", vim.lsp.buf.references, "Goto References")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>cr", vim.lsp.buf.rename, "Rename all references")
    end,
})

-- diagnostics
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "[diagnostics] Next Diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "[diagnostics] Prev Diagnostic" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[diagnostics] Line Diagnostics" })
