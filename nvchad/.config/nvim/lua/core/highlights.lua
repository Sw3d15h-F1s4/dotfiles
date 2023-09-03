local M = {}

---@type Base46HLGroupsList
M.override = {
    Comment = {
        italic = false,
    },
}

---@type HLTable
M.add = {
    NvimTreeOpenedFolderName = {fg = "green", bold = true},
    NvimTreeGitDirty = {fg = "pink"}
}

return M
