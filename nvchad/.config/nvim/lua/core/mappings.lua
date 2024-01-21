-- n, v, i, t = mode names

local M = {}

M.general = {
    i = {
        -- go to  beginning and end
        ["<C-b>"] = { "<ESC>^i", "Beginning of line" },
        ["<C-e>"] = { "<End>", "End of line" },

        -- navigate within insert mode
        ["<C-h>"] = { "<Left>", "Move left" },
        ["<C-l>"] = { "<Right>", "Move right" },
        ["<C-j>"] = { "<Down>", "Move down" },
        ["<C-k>"] = { "<Up>", "Move up" },
    },

    n = {
        ["<C-d>"] = { "<C-d>zz", opts = { silent = true } },
        ["<C-u>"] = { "<C-u>zz", opts = { silent = true } },
        ["n"] = { "nzzzv", "Center Search" },
        ["N"] = { "Nzzzv", "Center Search" },

        ["<Esc>"] = { ":noh <CR>", "Clear highlights", opts = { silent = true } },
        -- switch between windows
        ["<C-h>"] = { "<C-w>h", "Window left" },
        ["<C-l>"] = { "<C-w>l", "Window right" },
        ["<C-j>"] = { "<C-w>j", "Window down" },
        ["<C-k>"] = { "<C-w>k", "Window up" },

        -- save
        ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

        -- Copy all
        ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

        -- line numbers
        ["<leader>nn"] = { "<cmd> set nu! <CR>", "Toggle line number" },
        ["<leader>nr"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

        -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
        -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
        -- empty mode is same as using <cmd> :map
        -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
        -- ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true, silent = true } },
        -- ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true, silent = true } },
        -- ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true, silent = true } },
        -- ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true, silent = true } },

        -- new buffer
        ["<leader>b"] = { "<cmd> enew <CR>", "New buffer" },
        ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },

        ["<leader>lf"] = {
            function()
                vim.lsp.buf.format { async = true }
            end,
            "LSP formatting",
        },
        ["<C-Right>"] = { "<cmd> vertical resize +2<CR>", "Widen Window"},
        ["<C-Left>"] = { "<cmd> vertical resize -2<CR>", "Narrow Window"},
        ["<C-Down>"] = { "<cmd> resize +2<CR>", "Taller Window"},
        ["<C-Up>"] = { "<cmd> resize -2<CR>", "Shorten Window"}

    },

    t = {
        ["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
    },

    v = {
        -- ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true, silent = true} },
        -- ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true, silent = true } },

        ["K"] = { ":m '>-2<CR>gv=gv", "Move lines down", opts = { silent = true } },
        ["J"] = { ":m '>+1<CR>gv=gv", "Move lines up", opts = { silent = true } },
    },

    x = {
        -- ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true, silent = true} },
        -- ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true, silent = true} },
        -- Don't copy the replaced text after pasting in visual mode
        -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
        ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
    },
}

M.tabufline = {
    plugin = true,

    n = {
        -- cycle through buffers
        ["<S-l>"] = {
            function()
                require("nvchad.tabufline").tabuflineNext()
            end,
            "Goto next buffer",
        },

        ["<S-h>"] = {
            function()
                require("nvchad.tabufline").tabuflinePrev()
            end,
            "Goto prev buffer",
        },

        -- close buffer + hide terminal buffer
        ["Q"] = {
            function()
                require("nvchad.tabufline").close_buffer()
            end,
            "Close buffer",
        },
    },
}

M.comment = {
    plugin = true,

    -- toggle comment in both modes
    n = {
        ["<leader>/"] = {
            function()
                require("Comment.api").toggle.linewise.current()
            end,
            "Toggle comment",
        },
    },

    v = {
        ["<leader>/"] = {
            "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            "Toggle comment",
        },
    },
}

M.lspconfig = {
    plugin = true,

    -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

    n = {
        ["gD"] = {
            function()
                vim.lsp.buf.declaration()
            end,
            "LSP declaration",
        },

        ["gr"] = {function() vim.cmd("TroubleToggle lsp_references") end, "Peek References"},
        ["gd"] = {function() vim.cmd("TroubleToggle lsp_definitions") end, "Peek Definitions"},

        ["K"] = {
            function()
                vim.lsp.buf.hover()
            end,
            "LSP hover",
        },

        ["gi"] = {
            function()
                vim.lsp.buf.implementation()
            end,
            "LSP implementation",
        },

        ["<leader>ls"] = {
            function()
                vim.lsp.buf.signature_help()
            end,
            "LSP signature help",
        },

        ["<leader>D"] = {
            function()
                vim.lsp.buf.type_definition()
            end,
            "LSP definition type",
        },

        ["<leader>lr"] = {
            function()
                require("nvchad.renamer").open()
            end,
            "LSP rename",
        },

        ["<leader>la"] = {
            function()
                vim.lsp.buf.code_action()
            end,
            "LSP code action",
        },

        ["gl"] = {
            function()
                vim.diagnostic.open_float { border = "rounded" }
            end,
            "Floating diagnostic",
        },

        ["[d"] = {
            function()
                vim.diagnostic.goto_prev { float = { border = "rounded" } }
            end,
            "Goto prev",
        },

        ["]d"] = {
            function()
                vim.diagnostic.goto_next { float = { border = "rounded" } }
            end,
            "Goto next",
        },

        ["<leader>q"] = {
            function()
                vim.diagnostic.setloclist()
            end,
            "Diagnostic setloclist",
        },

        ["<leader>wa"] = {
            function()
                vim.lsp.buf.add_workspace_folder()
            end,
            "Add workspace folder",
        },

        ["<leader>wr"] = {
            function()
                vim.lsp.buf.remove_workspace_folder()
            end,
            "Remove workspace folder",
        },

        ["<leader>wl"] = {
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            "List workspace folders",
        },
    },

    v = {
        ["<leader>la"] = {
            function()
                vim.lsp.buf.code_action()
            end,
            "LSP code action",
        },
    },
}

M.nvimtree = {
    plugin = true,

    n = {
        -- toggle
        ["<leader>nt"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
        ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

        -- focus
        ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
    },
}

M.telescope = {
    plugin = true,

    n = {
        -- find
        ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
        ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
        ["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
        ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
        ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
        ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
        ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
        ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", "Show all diagnostics" },

        -- git
        ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
        ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },

        -- pick a hidden term
        ["<leader>ft"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

        -- theme switcher
        ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

        ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
    },
}

M.nvterm = {
    plugin = true,

    t = {
        -- toggle in terminal mode
        ["<A-i>"] = {
            function()
                require("nvterm.terminal").toggle "float"
            end,
            "Toggle floating term",
        },

        ["<A-h>"] = {
            function()
                require("nvterm.terminal").toggle "horizontal"
            end,
            "Toggle horizontal term",
        },

        ["<A-v>"] = {
            function()
                require("nvterm.terminal").toggle "vertical"
            end,
            "Toggle vertical term",
        },
    },

    n = {
        -- toggle in normal mode
        ["<A-i>"] = {
            function()
                require("nvterm.terminal").toggle "float"
            end,
            "Toggle floating term",
        },

        ["<A-h>"] = {
            function()
                require("nvterm.terminal").toggle "horizontal"
            end,
            "Toggle horizontal term",
        },

        ["<A-v>"] = {
            function()
                require("nvterm.terminal").toggle "vertical"
            end,
            "Toggle vertical term",
        },
    },
}

M.whichkey = {
    plugin = true,

    n = {
        ["<leader>wK"] = {
            function()
                vim.cmd "WhichKey"
            end,
            "Which-key all keymaps",
        },
        ["<leader>wk"] = {
            function()
                local input = vim.fn.input "WhichKey: "
                vim.cmd("WhichKey " .. input)
            end,
            "Which-key query lookup",
        },
    },
}

M.blankline = {
    plugin = true,

    n = {
        ["<leader>cc"] = {
            function()
                local ok, start = require("indent_blankline.utils").get_current_context(
                    vim.g.indent_blankline_context_patterns,
                    vim.g.indent_blankline_use_treesitter_scope
                )

                if ok then
                    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
                    vim.cmd [[normal! _]]
                end
            end,

            "Jump to current context",
        },
    },
}

M.gitsigns = {
    plugin = true,

    n = {
        -- Navigation through hunks
        ["]c"] = {
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    require("gitsigns").next_hunk()
                end)
                return "<Ignore>"
            end,
            "Jump to next hunk",
            opts = { expr = true },
        },

        ["[c"] = {
            function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    require("gitsigns").prev_hunk()
                end)
                return "<Ignore>"
            end,
            "Jump to prev hunk",
            opts = { expr = true },
        },

        -- Actions
        ["<leader>rh"] = {
            function()
                require("gitsigns").reset_hunk()
            end,
            "Reset hunk",
        },

        ["<leader>ph"] = {
            function()
                require("gitsigns").preview_hunk()
            end,
            "Preview hunk",
        },

        ["<leader>gb"] = {
            function()
                package.loaded.gitsigns.blame_line()
            end,
            "Blame line",
        },

        ["<leader>td"] = {
            function()
                require("gitsigns").toggle_deleted()
            end,
            "Toggle deleted",
        },
    },
}

M.vim_jukit = {
    plugin = true,
    n ={
        -- vim-jukit splits
        ["<leader>jso"] = {function() vim.cmd("call jukit#splits#output()") end, "Open Output"},
        ["<leader>jst"] = {function() vim.cmd("call jukit#splits#term()") end, "Open Terminal"},
        ["<leader>jsh"] = {function() vim.cmd("call jukit#splits#history()") end, "Open History"},
        ["<leader>jsa"] = {function() vim.cmd("call jukit#splits#output_and_history()") end, "Open Both Splits"},
        ["<leader>jsch"] = {function() vim.cmd("call jukit#splits#close_history()") end, "Close History"},
        ["<leader>jsco"] = {function() vim.cmd("call jukit#splits#close_output_split()") end, "Close Output"},
        ["<leader>jsca"] = {function() vim.cmd("call jukit#splits#close_output_and_history(1)") end, "Close Both Splits"},
        ["<leader>jch"] = {function() vim.cmd("call jukit#splits#show_last_cell_output(1)") end, "Show last cell output"},
        -- not implemented:
        --  scroll
        --  auto hist toggle
        --  set layout

        -- vim-jukit sending code
        ["<leader>jxc"] = {function() vim.cmd("call jukit#send#section(0)") end, "Execute Cell"},
        ["<leader>jxa"] = {function() vim.cmd("call jukit#send#all()") end, "Execute All Cells"},
        ["<leader>xt"] = {function() vim.cmd("call jukit#send#until_current_section()") end, "Execute All Cells"},
        -- not implemented:
        --  execute current line (why the fuck)

        -- vim-jukit cell manipulation
        ["<leader>jco"] = {function() vim.cmd("call jukit#cells#create_below(0)") end, "Create Code Cell Below"},
        ["<leader>jcO"] = {function() vim.cmd("call jukit#cells#create_above(0)") end, "Create Code Cell Above"},
        ["<leader>jct"] = {function() vim.cmd("call jukit#cells#create_below(1)") end, "Create Text Cell Below"},
        ["<leader>jcT"] = {function() vim.cmd("call jukit#cells#create_above(1)") end, "Create Text Cell Above"},
        ["<leader>jcd"] = {function() vim.cmd("call jukit#cells#delete()") end, "Delete Cell"},
        ["<leader>jcs"] = {function() vim.cmd("call jukit#cells#split()") end, "Split Cell"},
        ["<leader>jcm"] = {function() vim.cmd("call jukit#cells#merge_below()") end, "Merge Cell Below"},
        ["<leader>jcM"] = {function() vim.cmd("call jukit#cells#merge_above()") end, "Merge Cell Above"},
        ["<leader>jcj"] = {function() vim.cmd("call jukit#cells#move_down()") end, "Move Cell Down"},
        ["<leader>jck"] = {function() vim.cmd("call jukit#cells#move_up()") end, "Move Cell Up"},
        ["<leader>jod"] = {function() vim.cmd("call jukit#cells#delete_outputs(0)") end, "Delete Current Cell Output"},
        ["<leader>jad"] = {function() vim.cmd("call jukit#cells#delete_outputs(1)") end, "Delete All Cell Output"},
        -- not implemented:
        --   jump to next/prev cell

        -- vim-jukit ipynb conversion
        ["<leader>jnp"] = {function() vim.cmd("call jukit#convert#notebook_convert(\"jupyter-notebook\")") end, "Convert Notebook"},

    },
    v = {
        ["<leader>jxs"] = {function() vim.cmd("call jukit#send#selection()") end, "Execute Selection"}
    }
}

M.nabla = {
    plugin = true,
    n = {
        ["<leader>p"] = {function() require("nabla").popup() end, "Render TeX"},
    }
}

M.trouble = {
    plugin = true,
    n = {
        ["<leader>ld"] = {function() vim.cmd("TroubleToggle document_diagnostics") end, "Open Diagnostics"},
        ["<leader>lw"] = {function() vim.cmd("TroubleToggle workspace_diagnostics") end, "Open Workspace Diagnostics"},
    }
}

-- M.disabled = {
--   n = {
--     ["<leader>h"] = "",
--     ["<leader>ca"] = "",
--     ["<leader>cm"] = "",
--     ["<leader>fw"] = "",
--     ["<leader>ra"] = "",
--     ["<leader>rn"] = "",
--     ["<leader>n"] = "",
--     ["<leader>f"] = ""
--   }
-- }

return M
