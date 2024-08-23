require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "jk", "<ESC>")
map("t", "<Esc>", "<C-\\><C-N>", {desc = "Exit insert Mode in Terminal"})
map("n", "<leader>dui", "<Cmd>lua require('dapui').toggle()<CR>", {desc = "Debugger Toggle UI"})
map("n", "<leader>db", "<Cmd>DapToggleBreakpoint<CR>", {desc = "Debugger Toggle Breakpoint"})
map("n", "<leader>dr", "<Cmd>DapContinue<CR>", {desc = "Debugger Run Programm"})
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
