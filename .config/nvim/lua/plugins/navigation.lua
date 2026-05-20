-- lua/plugins/navigation.lua
return {

  -- ── File tree ─────────────────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        window = {
          width = 30,
          mappings = {
            ["<space>"] = "none",   -- don't conflict with leader
            ["l"] = "open",
            ["h"] = "close_node",
            ["v"] = "open_vsplit",
            ["s"] = "open_split",
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,    -- show dotfiles (useful for configs)
            hide_gitignored = true,
          },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        default_component_configs = {
          indent = { with_expanders = true },
          icon = {
            folder_closed = "",
            folder_open   = "",
            folder_empty  = "󰜌",
          },
          git_status = {
            symbols = {
              added     = "✚",
              modified  = "",
              deleted   = "✖",
              renamed   = "󰁕",
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            },
          },
        },
      })
    end,
  },

  -- ── Telescope (fuzzy finder) ───────────────────────────────────────
  -- Even without IDE features, this is invaluable for navigating files
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
        },
      })

      telescope.load_extension("fzf")

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",             { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",              { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",                { desc = "Find buffers" })
      map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",              { desc = "Help tags" })
      map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>",               { desc = "Recent files" })
      map("n", "<leader>fc", "<cmd>Telescope grep_string<CR>",            { desc = "Grep word under cursor" })
      map("n", "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy in buffer" })
    end,
  },

}
