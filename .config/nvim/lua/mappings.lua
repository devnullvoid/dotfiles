require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>cd", "<cmd> cd %:p:h <CR>", { desc = "cd to current file dir" })
map("n", "<leader>cc", "<cmd> :Telescope <CR>", { desc = "Open Telescope" })
map("n", "<s-h>", "^", { desc = "start of line" })
map("n", "<s-l>", "$", { desc = "end of line" })
map("n", "<c-/>", "gcc", { desc = "toggle comment", remap = true })

-- Visual mode mappings
map("v", ">", ">gv", { desc = "indent" })
map("v", "<c-/>", "gc", { desc = "toggle comment", remap = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>tt", ":lua require('base46').toggle_transparency()<CR>", { noremap = true, silent = true, desc = "Toggle Background Transparency" })
map("i", "<c-/>", "<esc>gcc", { desc = "toggle comment", remap = true })
