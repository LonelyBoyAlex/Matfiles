-- lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked text briefly
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("TrimWhitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Restore cursor position when reopening a file
autocmd("BufReadPost", {
  group = augroup("RestoreCursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto resize splits when terminal is resized
autocmd("VimResized", {
  group = augroup("AutoResize", { clear = true }),
  command = "tabdo wincmd =",
})

-- Close certain windows with just q
autocmd("FileType", {
  group = augroup("QuickClose", { clear = true }),
  pattern = { "help", "man", "qf", "lspinfo", "checkhealth", "lazy" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
  end,
})

-- Relative numbers only in focused normal-mode window
local numgroup = augroup("SmartNumbers", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = numgroup,
  callback = function()
    if vim.opt.number:get() then vim.opt.relativenumber = true end
  end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = numgroup,
  callback = function()
    if vim.opt.number:get() then vim.opt.relativenumber = false end
  end,
})
