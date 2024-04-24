if string.find(vim.loop.os_uname().release, "5.4.2") then
  vim.g.ANDROID = true
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- Completely disable clipboard sync on Android
-- termux-clipboard takes ~ 3 seconds per request.
-- plus you can just highlight copy/paste in termux, press i and tap/hold

if (vim.g.ANDROID ~= true) then
  vim.opt.clipboard = 'unnamedplus'
else
  vim.g.clipboard = {
    name = 'disable-clipboard',
    copy = {
      ['+'] = true,
      ['*'] = true,
    },
    paste = {
      ['+'] = true,
      ['*'] = true,
    },
    cache_enabled = 1,
  }
end

-- Enable break indent
vim.opt.breakindent = true

-- Don't Save undo history
vim.opt.undofile = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
vim.opt.sidescroll = 8

vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = '[D]iagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])


-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  {
    -- File Tree.
    -- TODO: find a new one neotree kinda ass
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<C-n>",      "<cmd> Neotree toggle <CR>",                 desc = "Toggle [N]eotree" },
      { "<leader>e",  "<cmd> Neotree focus source=filesystem<CR>", desc = "[E]xplore Files" },
      { "<leader>gs", "<cmd> Neotree focus source=git_status<CR>", desc = "[G]it [S]tatus" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      window = {
        width = 30,
      },
      source_selector = {
        winbar = true
      }
    },
    config = true,
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    -- See `:help gitsigns` to understand what the configuration keys do
    'lewis6991/gitsigns.nvim',
    event = "BufEnter",
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = bufnr, silent = true })
        end

        map("n", "]c",
          function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() require('gitsigns').next_hunk() end)
            return "<Ignore>"
          end,
          "Move to next Git hunk")

        map("n", "[c",
          function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() require('gitsigns').prev_hunk() end)
            return "<Ignore>"
          end,
          "Move to prev Git hunk")

        map("n", "<leader>gr", require('gitsigns').reset_hunk, "[G]it [R]eset Hunk")
        map("n", "<leader>gp", require('gitsigns').preview_hunk, "[G]it [P]review Hunk")
        map("n", "<leader>gb", package.loaded.gitsigns.blame_line, "[G]it [B]lame")
        map("n", "<leader>gt", require('gitsigns').toggle_deleted, "[G]it [T]oggle Delted")
      end
    },
  },

  {                     -- Useful plugin to show you pending keybinds.
    -- NOTE: im too lazy to use mini.clue properly. also this works with ciq
    -- maybe, maybe i spend some time documenting all my keybinds
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      }
    end,
  },

  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    keys = {
      { '<leader>sh', '<cmd>Telescope help_tags<CR>',   desc = "[S]earch [H]elp" },
      { '<leader>sk', '<cmd>Telescope keymaps<CR>',     desc = "[S]earch [K]eymaps" },
      { '<leader>sf', '<cmd>Telescope find_files<CR>',  desc = "[S]earch [F]iles" },
      { '<leader>st', '<cmd>Telescope builtin<CR>',     desc = "[S]earch [T]elescopes" },
      { '<leader>sw', '<cmd>Telescope grep_string<CR>', desc = "[S]earch [W]ord" },
      { '<leader>sg', '<cmd>Telescope live_grep<CR>',   desc = "[S]earch by [G]rep" },
      { '<leader>sd', '<cmd>Telescope diagnostics<CR>', desc = "[S]earch [D]iagnostics" },
      { '<leader>sr', '<cmd>Telescope resume<CR>',      desc = "[S]earch [R]esume" },
      { '<leader>s.', '<cmd>Telescope oldfiles<CR>',    desc = "[S]earch Recents [.]" },
      { '<leader>sc', '<cmd>Telescope git_status<CR>',  desc = "[S]earch [C]ommits" },
      {
        '<leader><leader>',
        function()
          require('telescope.builtin').buffers(require('telescope.themes')
            .get_dropdown({ previewer = false }))
        end,
        desc = "[ ] Find Buffers"
      },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes')
            .get_dropdown({ previewer = false }))
        end,
        desc = "[/] Fuzzy search in current buffer"
      },
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep({
            grep_open_files = true,
            prompt_title =
            "Live Grep in Open Files"
          })
        end,
        desc = "[S]earch [/] in open files"
      },
      { '<leader>sn', function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath 'config' }) end, desc = "[S]earch [N]vim Config" },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          mappings = {
            n = { ["q"] = require("telescope.actions").close },
          },
        },
      }
      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'ui-select')
    end,
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspLog", "LspStart", "LspRestart" },
    dependencies = {

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim',                 config = true },

      -- Let's try Mason again. Won't work on Android, but whatever.
      { 'williamboman/mason.nvim',           enabled = not vim.g.ANDROID },
      { 'williamboman/mason-lspconfig.nvim', enabled = not vim.g.ANDROID },
      'folke/trouble.nvim',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          map('<leader>df', vim.lsp.buf.format, '[D]ocument [F]ormat')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {},

        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportUnusedExpression = "none",
                }
              }
            }
          }
        },
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "tectonic",
                args = {
                  "-X",
                  "compile",
                  "%f",
                  [[--synctex]],
                  [[--keep-logs]],
                  [[--keep-intermediates]],
                }
              }
            }
          }
        }
      }



      if not vim.g.ANDROID then -- Check if works on NixOS with nix-ld and nix-alien
        require('mason').setup()
        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end

      if vim.g.ANDROID then -- if we are on android, then mason's binaries don't work
        local setup_server = function(server_name)
          local server = servers[server_name]
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end
        vim.tbl_map(setup_server, vim.tbl_keys(servers))
      end
    end,
  },

  {
    -- FIX: looks like nvim-cmp is more performant than mini.completion sadly.
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },

      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    -- Colorscheme
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme 'tokyonight-night'
    end,
    opts = {
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },

  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  {
    'folke/trouble.nvim',
    lazy = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
    },
    config = function(_, opts)
      require('trouble').setup(opts)

      vim.keymap.set('n', '<leader>dd', function() require('trouble').toggle('document_diagnostics') end,
        { silent = true, desc = "[D]ocument [D]iagnostics" })
      vim.keymap.set('n', '<leader>wd', function() require('trouble').toggle('workspace_diagnostics') end,
        { silent = true, desc = "[W]orkspace [D]iagnostics" })
      vim.keymap.set('n', '<leader>q', function() require('trouble').toggle('quickfix') end,
        { silent = true, desc = "[Q]uickfix" })
      vim.keymap.set('n', 'gr', function() require('trouble').toggle('lsp_references') end,
        { silent = true, desc = "[G]oto [R]eferences" })
    end,
  },

  {
    "jbyuki/nabla.nvim",
    keys = {
      { "<leader>p",  function() require('nabla').popup() end,       desc = "[P] Popup LaTeX Eqns" },
      { "<leader>dp", function() require('nabla').toggle_virt() end, desc = "[P] Toggle LaTeX Eqns" },
    }
  },
  {
    "jbyuki/venn.nvim",
    cmd = "VBox",
    keys = {
      {'<leader>v', desc = "Toggle Venn"},
    },
    config = function()
      local function toggle_venn()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          ---@diagnostic disable-next-line 
          vim.b.venn_enabled = true
          vim.cmd [[setlocal ve=all]]
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
        else
          vim.cmd [[setlocal ve=]]
          vim.cmd [[mapclear <buffer>]]
          ---@diagnostic disable-next-line 
          vim.b.venn_enabled = nil
        end
      end
      vim.keymap.set("n", "<leader>v", function() toggle_venn() end, { desc = "Toggle Venn" })
    end,
  },

  {
    "folke/flash.nvim",
    config = true,
    keys = {
      { "S", function() require('flash').jump() end, desc = "Flash" },
    }
  },
  {
    -- Adds new a/i textobjects
    'echasnovski/mini.ai',
    opts = { n_lines = 500 },
    event = "InsertEnter",
    config = true,
  },
  {
    -- Adds the ability to surround text
    'echasnovski/mini.surround',
    event = "InsertEnter",
    config = true,
  },
  {
    -- Toggle comments in visual mode
    'echasnovski/mini.comment',
    config = true,
    keys = {
      { "gc", desc = "Toggle Comment", mode = "n" },
      { "gc", desc = "Toggle Comment", mode = "v" },
    },
  },
  {
    -- Close buffers like a normal person
    'echasnovski/mini.bufremove',
    config = true,
    keys = {
      { "Q", function() require('mini.bufremove').delete() end, desc = "Delete Buffer" }
    }
  },
  {
    -- Autopairs (sorry teej)
    'echasnovski/mini.pairs',
    event = "InsertEnter",
    config = true,
  },
  {
    -- we like me some status lines
    'echasnovski/mini.statusline',
    opts = { use_icons = true },
    config = true,
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        }
      }
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    cmd = "ToggleTerm",
    keys = {
      { "<A-i>",      "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle Terminal", mode = "n" },
      { "<A-i>",      "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle Terminal", mode = "t" },
      { "<leader>gs", desc = "Toggle Terminal" },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })

      local function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>gs", _lazygit_toggle, { noremap = true, silent = true, desc = '[G]it [S]tatus' })
    end,
  },
  {
    "stevearc/dressing.nvim",
    config = true,
  },
  {
    "nvim-pack/nvim-spectre",
    config = true,
    keys = {
      { "<leader>S", function() require('spectre').open() end, desc = "Spectre [S]earch" },
    }
  },
  {
    'mfussenegger/nvim-dap',
    enabled = not vim.g.ANDROID,
    keys = {
      { "<F5>",      function() require('dap').continue() end,                                               desc = "Debug: Start/Continue" },
      { "<F1>",      function() require('dap').step_into() end,                                              desc = "Debug: Step Into" },
      { "<F2>",      function() require('dap').step_over() end,                                              desc = "Debug: Step Over" },
      { "<F3>",      function() require('dap').step_out() end,                                               desc = "Debug: Step Out" },
      { "<leader>b", function() require('dap').toggle_breakpoint() end,                                      desc = "Debug: Toggle Breakpoint" },
      { "<leader>B", function() require('dap').toggle_breakpoint(vim.fn.input 'Breakpoint Condition: ') end, desc = "Debug: Set Breakpoint" },
      { "<F7>",      function() require('dapui').toggle() end,                                               desc = "Debug: Toggle UI" }
    },
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_setup = true,

        handlers = {},
      }

      dapui.setup {
        layouts = { {
          elements = { {
            id = "scopes",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "stacks",
            size = 0.25
          }, {
            id = "watches",
            size = 0.25
          } },
          position = "right",
          size = 40
        }, {
          elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
          position = "bottom",
          size = 10
        } },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      {
        "GCBallesteros/jupytext.nvim",
        lazy = false,
        opts = {
          style = "percent",
          output_extension = "py"
        },
      },
      {
        "benlubas/molten-nvim",
        build = ":UpdateRemotePlugins",
      },
      {
        "echasnovski/mini.hipatterns",
      },
      {
        "echasnovski/mini.ai",
      },
    },
    ft = "python",
    opts = {
      repl_provider = "molten",
      syntax_highlight = true,
      cell_highlight_group = "Folded",
    },
    config = function(_, opts)
      local nn = require 'notebook-navigator'
      nn.setup(opts)
      require('mini.hipatterns').setup({ highlighters = { cells = nn.minihipatterns_spec } })
      require('mini.ai').setup({ textobjects = { h = nn.miniai_spec } })
    end,
    keys = {
      { "]h",        function() require('notebook-navigator').move_cell('d') end },
      { "[h",        function() require('notebook-navigator').move_cell('u') end },
      { "<leader>X", function() require('notebook-navigator').run_cell() end },
      { "<leader>x", function() require('notebook-navigator').run_and_move() end },
    },
  },
  {
    cmd = "CellularAutomaton",
    "Eandrju/cellular-automaton.nvim",
  }
})

-- lua-language-server root directory detection is kinda funky on windows.
-- seems that by default, will only find when directory has a .stylua.toml file
-- even tho i dont use stylua.
if vim.loop.os_uname().sysname == "Windows_NT" then
  local configpath = vim.fn.stdpath 'config' .. '/.stylua.toml'
  if not vim.loop.fs_stat(configpath) then
    os.execute('type nul > ' .. configpath)
  end
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
