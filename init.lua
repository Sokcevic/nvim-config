vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = ","

vim.opt.shell = "/usr/bin/zsh"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

require("barbecue").setup {
  show_modified = true,
}

local dap = require "dap"
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = "/home/lukassokcevic/DebugTools/cpptools-linux/extension/debugAdapters/bin/OpenDebugAD7", -- Update this path
  options = {
    detached = false,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},

    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
    miDebuggerPath = "gdb", -- Ensure this points to your gdb executable
  },
}
dap.configurations.c = dap.configurations.cpp
require("dap").set_log_level "DEBUG"
require("dapui").setup()
