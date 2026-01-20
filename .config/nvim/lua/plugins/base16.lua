return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true

    -- Your matugen file already calls setup() - just source it
    require("matugen.base16") -- Runs the setup + custom highlights

    -- Configure plugin integrations
    require("base16-colorscheme").with_config({
      telescope = true,
      indentblankline = true,
      cmp = true,
      lualine = true,
    })
  end,
}
