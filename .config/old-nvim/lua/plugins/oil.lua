return {
  "stevearc/oil.nvim",
  config = function()
    local oil = require("oil")
    oil.setup({
     float = {
        padding = 4,
        max_width = 0.7,
        max_height = 0.8,
        border = "rounded",  -- Options: "rounded", "single", "double", "shadow"
        win_options = {
          winblend = 0,
        },
      },
    })
    vim.keymap.set("n", "-", oil.toggle_float, {})
  end,
}
