-- lua/core/keymaps.lua
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Better defaults ────────────────────────────────────────────────────
-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Don't yank on paste (paste over selection without losing register)
map("x", "p", '"_dP')

-- Delete without yanking
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete (no yank)" })

-- Yank to system clipboard explicitly if needed
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- ── Text manipulation ──────────────────────────────────────────────────
-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Move lines up/down in normal mode
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Join line without moving cursor
map("n", "J", "mzJ`z")

-- Indent/dedent and stay in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Better word replace (replace word under cursor)
map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })

-- ── Buffers ────────────────────────────────────────────────────────────
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprev<CR>", { desc = "Prev buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>X", ":bdelete!<CR>", { desc = "Force close buffer" })

-- ── Splits / Windows ──────────────────────────────────────────────────
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sc", "<C-w>q", { desc = "Close split" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize splits
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- ── File tree ─────────────────────────────────────────────────────────
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus file tree" })

-- ── Misc ──────────────────────────────────────────────────────────────
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })

-- Quick open config
map("n", "<leader>vc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit init.lua" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })
