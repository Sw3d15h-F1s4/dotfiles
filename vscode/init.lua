local keymap = vim.keymap.set
local opts = { silent = true }

keymap("", "<Space>", "<Nop>", opts)

vim.g.mapleader = " "

-- Better window navigation (not gonna happen in vs code)
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", "<cmd>lua require('vscode-neovim').call('workbench.action.decreaseViewHeight')<CR>", opts)
keymap("n", "<C-Down>", "<cmd>lua require('vscode-neovim').call('workbench.action.increaseViewHeight')<CR>", opts)
keymap("n", "<C-Left>", "<cmd>lua require('vscode-neovim').call('workbench.action.decreaseViewWidth')<CR>", opts)
keymap("n", "<C-Right>", "<cmd>lua require('vscode-neovim').call('workbench.action.increaseViewWidth')<CR>", opts)

-- Navigate Buffers (handled in keybindings.json)
--keymap("n", "<S-l>", "<cmd>tabn<CR>", opts)
--keymap("n", "<S-h>", "<cmd>tabp<CR>", opts)
-- {
--     "key": "shift+h",
--     "command": "workbench.action.previousEditor",
--     "when": "neovim.mode != insert"
-- },
-- {
--     "key": "shift+l",
--     "command": "workbench.action.nextEditor",
--     "when": "neovim.mode != insert"
-- },

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>tabc<CR>", opts)

-- Better paste
-- keymap("v", "p", "P", opts)

-- Insert --
-- Press jk fast to enter (do this in keybindings.json as well, personally not a fan)
-- keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- My keymaps
-- keymap('n', '<C-d>', '<C-d>zz', opts) -- this one makes me so sad. <C-d/u> scrolls the window but doesn't move the cursor, so zz won't behave as expected.
-- keymap('n', '<C-u>', '<C-u>zz', opts)
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts) --honestly these suck and are glitchy but editor.action.moveLinesDownAction doesn't work in visual select.
keymap('v', 'K', ":m '>-2<CR>gv=gv", opts) --and this moves the visual selection with the text. weird shit.
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)

keymap("n", "<leader>e", "<cmd>lua require('vscode-neovim').call('workbench.view.explorer')<CR>", opts)

-- LSP bindings (your standard lsp on_attach)
keymap("n", "<leader>lf", "<cmd>lua require('vscode-neovim').call('editor.action.formatDocument')<CR>", opts)
keymap("n", "<leader>lr", "<cmd>lua require('vscode-neovim').call('editor.action.rename')<CR>", opts)
keymap("n", "<leader>la", "<cmd>lua require('vscode-neovim').call('editor.action.quickFix')<CR>", opts)
keymap("n", "<leader>lj", "<cmd>lua require('vscode-neovim').call('editor.action.marker.next')<CR>", opts)
keymap("n", "<leader>lk", "<cmd>lua require('vscode-neovim').call('editor.action.marker.prev')<CR>", opts)
keymap("n", "<leader>ls", "<cmd>lua require('vscode-neovim').call('editor.action.triggerParameterHints')<CR>", opts)

keymap("n", "gI", "<cmd>lua require('vscode-neovim').call('editor.action.peekImplementation')<CR>", opts)
keymap("n", "gr", "<cmd>lua require('vscode-neovim').call('editor.action.referenceSearch.trigger')<CR>", opts)

-- Telescope, or well almost. I think quickOpen is limited to current workspace files. also openRecent as a projects menu is kinda stretching it.
keymap('n', '<leader>ff', "<cmd>lua require('vscode-neovim').call('workbench.action.quickOpen')<CR>", opts)
keymap('n', '<leader>ft', "<cmd>lua require('vscode-neovim').call('workbench.action.findInFiles')<CR>", opts)
keymap('n', '<leader>fp', "<cmd>lua require('vscode-neovim').call('workbench.action.openRecent')<CR>", opts)
-- keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts) -- doesn't make sense


-- -- Git who needs lazygit
keymap('n', '<leader>gg', "<cmd>lua require('vscode-neovim').call('workbench.view.scm')<CR>", opts)
keymap('n', '<leader>xx', "<cmd>lua require('vscode-neovim').call('workbench.view.extensions')<CR>", opts)

-- -- Comment
keymap('n', "<leader>/", "<cmd>lua require('vscode-neovim').call('editor.action.commentLine')<CR>", opts)
keymap('x', "<leader>/", "<cmd>lua require('vscode-neovim').call('editor.action.commentLine')<CR>", opts)

-- -- DAP no idea how useful this actually is, but its possible and was how nvim-basic-ide binds it. works for me ig.
keymap('n', "<leader>du", "<cmd>lua require('vscode-neovim').call('workbench.view.debug')<CR>", opts)
keymap('n', "<leader>db", "<cmd>lua require('vscode-neovim').call('editor.debug.action.toggleBreakpoint')<CR>", opts)
keymap('n', "<leader>dc", "<cmd>lua require('vscode-neovim').call('workbench.debug.action.continue')<CR>", opts)
keymap('n', "<leader>di", "<cmd>lua require('vscode-neovim').call('workbench.debug.action.stepInto')<CR>", opts)
keymap('n', "<leader>do", "<cmd>lua require('vscode-neovim').call('workbench.debug.action.stepOver')<CR>", opts)
keymap('n', "<leader>dO", "<cmd>lua require('vscode-neovim').call('workbench.debug.action.stepOut')<CR>", opts)
keymap('n', "<leader>dr", "<cmd>lua require('vscode-neovim').call('workbench.debug.action.toggleRepl')<CR>", opts)
keymap('n', "<leader>dl", "<cmd>lua require('vscode-neovim').call('workbench.action.debug.run')<CR>", opts)
keymap('n', "<leader>dl", "<cmd>lua require('vscode-neovim').call('workbench.action.debug.terminateThread')<CR>", opts)-- 
