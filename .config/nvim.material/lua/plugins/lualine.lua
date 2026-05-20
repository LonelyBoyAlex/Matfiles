return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local colors = require("matugen.base16") -- Access base16 palette
    return vim.tbl_deep_extend("force", opts, {
      options = {
        theme = "base16",
      },
    })
  end,
}
