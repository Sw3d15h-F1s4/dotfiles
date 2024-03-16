if string.find(vim.loop.os_uname().release, "5.4.2") then
  vim.g.ANDROID = true
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`

if (vim.g.ANDROID ~= true) then
  vim.opt.clipboard = 'unnamedplus'
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

vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.termguicolors = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", {silent = true})
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", {silent = true})
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
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({

  -- nvim-tree
  {
    -- File Tree.
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      git = {
        enable = true,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
    },

    config = function(_, opts)
      require('nvim-tree').setup(opts)

      vim.keymap.set('n', '<C-n>', '<cmd> NvimTreeToggle <CR>')
      vim.keymap.set('n', '<leader>e', '<cmd> NvimTreeFocus <CR>')
    end,
  },

  {
    -- Bufferline/tabline
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "",
            separator = true,
          }
        },
        custom_filter = function(buf_number, buf_numbers)
          if vim.bo[buf_number].filetype ~= "NvimTree" then return true end
        end,
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)

      vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>')
      vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>')
    end,
  },

  {
    'famiu/bufdelete.nvim',
    keys = {
      {"Q", "<cmd> Bdelete! <CR>", desc = "[Q] Close Buffer"}
    },
  },

  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },


  {
    -- comment visual regions/lines
    'numToStr/Comment.nvim',
    opts = {},
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    -- See `:help gitsigns` to understand what the configuration keys do
    'lewis6991/gitsigns.nvim',
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

        map("n", "<leader>rh", require('gitsigns').reset_hunk, "Reset Hunk")
        map("n", "<leader>ph", require('gitsigns').preview_hunk, "Preview Hunk")
        map("n", "<leader>gb", package.loaded.gitsigns.blame_line, "Preview Hunk")
        map("n", "<leader>td", require('gitsigns').toggle_deleted, "Toggle DeleteToggle Deleted")

      end
    },
  },

  {                     -- Useful plugin to show you pending keybinds.
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
        ['<leader>l'] = { name = '[L]SP Binds', _ = 'which_key_ignore' },
      }
    end,
  },

  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
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

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sg', builtin.git_status, { desc = '[S]how [G]it Status' })
      vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = '[S]earch [C]ommits' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },

      -- Let's try Mason again. Won't work on Android, but whatever.
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
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
      }

      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      if not vim.g.ANDROID then -- Check if works on NixOS with nix-ld and nix-alien
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

        setup_server('lua_ls')
        setup_server('clangd')
      end
    end,
  },

  {
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
    init = function()
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
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
    },
    config = function(_, opts)
      require('trouble').setup(opts)

      vim.keymap.set('n', '<leader>dd', function() require('trouble').toggle('document_diagnostics') end, {silent = true, desc = "[D]ocument [D]iagnostics"})
      vim.keymap.set('n', '<leader>wd', function() require('trouble').toggle('workspace_diagnostics') end, {silent = true, desc = "[W]orkspace [D]iagnostics"})
      vim.keymap.set('n', '<leader>q', function() require('trouble').toggle('quickfix') end, {silent = true, desc = "[Q]uickfix"})
      vim.keymap.set('n', '<leader>ll', function() require('trouble').toggle('quickfix') end, {silent = true, desc = "[L]ocation [L]ist"})
      vim.keymap.set('n', 'gr', function() require('trouble').toggle('lsp_references') end, {silent = true, desc = "[G]oto [R]eferences"})
    end,
  },

  {
    -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Around/Inside
      require('mini.ai').setup { n_lines = 500 }

      -- Surround
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
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
    opts = {

    },
    config = function(_, opts)
      require('toggleterm').setup(opts)

    vim.keymap.set('n', '<A-i>', '<cmd>ToggleTerm direction=float<CR>', {silent=true, desc = '[T]oggle [T]erm'})
    vim.keymap.set('t', '<A-i>', '<cmd>ToggleTerm direction=float<CR>', {silent=true, desc = '[T]oggle [T]erm'})
    end,
  },

}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
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
