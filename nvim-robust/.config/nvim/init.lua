-- Sam's Very Small Nvim Config

vim.cmd(":colorscheme lunaperche")

-- Keymapping
vim.g.mapleader = " "
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>e', ':25Lex!<cr>')
vim.keymap.set('n', '<leader>t', ':tabnew<cr>')
vim.keymap.set('n', '<leader>q', ':tabc<cr>')

-- Settings
vim.opt.scrolloff = 8
vim.opt.nu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.colorcolumn = "100"
vim.opt.wrap = false
vim.opt.completeopt = 'menuone'

-- LSP No way?

-- LSP Keybindings
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = args.buf })
        vim.keymap.set('n', 'gD', vim.lsp.buf.definition, { buffer = args.buf })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = args.buf })
        vim.keymap.set('n', 'gR', vim.lsp.buf.references, { buffer = args.buf })
    end,
})

-- Starting Lua Language Server
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function(args)

        if vim.fn.executable('lua-language-server') ~= 1 then
            return
        end

        local root_dir = vim.fs.dirname(
            vim.fs.find(
                { 'init.lua', '.git', '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml',
                    'selene.toml', 'selene.yml' }, { upward = true })[1]
        )

        local library = {}
        local path = vim.split(package.path, ";")

        table.insert(path, "lua/?.lua")
        table.insert(path, "lua/?/init.lua")

        local function add(lib)
            for _, p in pairs(vim.fn.expand(lib, false, true)) do
                p = vim.loop.fs_realpath(p)
                library[p] = true
            end
        end

        add("$VIMRUNTIME")
        add("~/.config/nvim")

        local client = vim.lsp.start({
            name = 'lua-ls',
            cmd = { 'lua-language-server' },
            root_dir = root_dir,
            settings = {
                Lua = {
                    telemetry = { enable = false },
                    runtime = {
                        version = 'LuaJIT',
                        path = path
                    },
                    completion = { callSnippet = "Both" },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = library,
                        maxPreload = 2000,
                        preloadFileSize = 50000
                    }
                }
            }

        })
        vim.lsp.buf_attach_client(args.buf, client)
    end
})
