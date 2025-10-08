-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>cd", "<cmd> cd %:p:h <CR>", { desc = "cd to current file dir" })
-- map("n", "<leader>cc", "<cmd> :Telescope <CR>", { desc = "Open Telescope" })
map("n", "<s-h>", "^", { desc = "start of line" })
map("n", "<s-l>", "$", { desc = "end of line" })
map("n", "<c-/>", "gcc", { desc = "toggle comment", remap = true })
map("n", "<leader>bn", "<cmd> bnext <CR>", { desc = "next buffer" })
map("n", "<leader>bp", "<cmd> bprevious <CR>", { desc = "previous buffer" })

-- Visual mode mappings
map("v", ">", ">gv", { desc = "indent" })
map("v", "<c-/>", "gc", { desc = "toggle comment", remap = true })

map("i", "<c-/>", "<esc>gcc", { desc = "toggle comment", remap = true })
