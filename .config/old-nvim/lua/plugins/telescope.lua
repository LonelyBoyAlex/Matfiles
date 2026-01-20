return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
      defaults = {
        -- This section hides specific "bloat" folders
        file_ignore_patterns = {
          "%.git/",
          "%.cache",
          "Code %- OSS",
          "%.local",
          "%thorium",
          "%.pydev_vscode",
          "%.mypy_cache",
          "%.jd",
          "%.themes",
          "%.cargo",
          "node_modules",
        },
      },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      --vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<C-p>", function()
        builtin.find_files({ hidden = true })
      end, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})

      require("telescope").load_extension("ui-select")
    end,
  },
}
