-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {
  base46 = {
    theme = "bearded-arc",
    pkgs = {
      "lua-language-server",
      "stylua",
      "html-lsp",
      "css-lsp",
      "prettier",
      "jdtls",
      "clangd",
      "pyright",
      "java-debug-adapter",
    },

    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
  },
  lsp = { signature = false },
}

return M
