vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.showmode = false


vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8
vim.opt.sidescroll = 8

vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.fillchars = 'eob: '

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count=-1}) end, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count= 1}) end, { desc = 'Go to next Diagnostic message' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.lsp.config["lua-language-server"] = {
  cmd = {"lua-language-server"},
  root_markers = { ".luarc.json", "init.lua" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  }
}

vim.lsp.config["clangd"] = {
  cmd = {"clangd"},
  root_markers = {"compile_commands.json",".clangd","compile_flags.txt"},
  filetypes = { "c","cpp","objc","objcpp","cuda","proto"},
}

vim.lsp.config["pyright"] = {
  cmd = {"pyright-langserver", "--stdio"},
  root_markers = {"main.py"},
  filetypes = { "python"},
}

vim.lsp.config["texlab"] = {
  cmd = {"texlab"},
  root_markers = {".git", "Tectonic.toml","texlabroot",".latexmkrc","main.tex"},
  filetypes = {"tex", "plaintex", "latex", "bib"},
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

vim.lsp.enable({"lua-language-server", "clangd", "pyright", "texlab"})


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
    end
  end,
})

vim.cmd("set completeopt+=noselect")

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
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<C-n>",     "<cmd>NvimTreeToggle<CR>", desc = "Toggle Nvim-tree" },
      { "<leader>e", "<cmd>NvimTreeFocus<CR>",  desc = "Explore Files" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
    },
    config = true,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufEnter",
    config = true,
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = true,
    opts = {
    }
  },

  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    keys = {
      { '<leader>sh', '<cmd>Telescope help_tags<CR>',   desc = "Search Help" },
      { '<leader>sk', '<cmd>Telescope keymaps<CR>',     desc = "Search Keymaps" },
      { '<leader>sf', '<cmd>Telescope find_files<CR>',  desc = "Search Files" },
      { '<leader>st', '<cmd>Telescope builtin<CR>',     desc = "Search Telescopes" },
      { '<leader>sw', '<cmd>Telescope grep_string<CR>', desc = "Search Word" },
      { '<leader>sg', '<cmd>Telescope live_grep<CR>',   desc = "Search by Grep" },
      { '<leader>sd', '<cmd>Telescope diagnostics<CR>', desc = "Search Diagnostics" },
      { '<leader>sr', '<cmd>Telescope resume<CR>',      desc = "Search Resume" },
      { '<leader>s.', '<cmd>Telescope oldfiles<CR>',    desc = "Search Recents" },
      { '<leader>sc', '<cmd>Telescope git_status<CR>',  desc = "Search Commits" },
      {
        '<leader><leader>',
        function()
          require('telescope.builtin').buffers(require('telescope.themes')
            .get_dropdown({ previewer = false }))
        end,
        desc = "Find Buffers"
      },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes')
            .get_dropdown({ previewer = false }))
        end,
        desc = "Fuzzy search in current buffer"
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
        desc = "Search in open files"
      },
      { '<leader>sn', function() require('telescope.builtin').find_files({ cwd = vim.fn.stdpath 'config' }) end, desc = "Search Nvim Config" },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
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
    end,
  },

  {
    'rose-pine/neovim',
    name="rose-pine",
    priority = 1000,
    opts = {
      dim_inactive_windows = true,
      styles = {
        italic = false,
      }
    },
    config = function(_, opts)
      require('rose-pine').setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end
  },

  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
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
    -- we like me some status lines
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    opts = {
      extensions = {
        'nvim-tree',
        'toggleterm',
        'quickfix',
      }
    },
    config = true,
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
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

      vim.keymap.set("n", "<leader>gs", _lazygit_toggle, { noremap = true, silent = true, desc = 'Git Status' })
    end,
  }
})

-- vim: ts=2 sts=2 sw=2 et
