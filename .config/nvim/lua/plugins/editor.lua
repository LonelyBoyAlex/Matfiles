-- lua/plugins/editor.lua
return {

  -- ── Surround (ys, cs, ds) ──────────────────────────────────────────
  -- ysiw"  → surround word with "
  -- cs"'   → change " to '
  -- ds"    → delete surrounding "
  -- yss)   → surround whole line with ()
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- ── Auto pairs ─────────────────────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = false,   -- no treesitter needed
        disable_filetype = { "TelescopePrompt" },
      })
    end,
  },

  -- ── Comments ───────────────────────────────────────────────────────
  -- gcc  → toggle line comment
  -- gc   → toggle comment (motion/visual)
  -- gcip → comment inner paragraph
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("Comment").setup()
    end,
  },

  -- ── Flash (supercharged motions) ───────────────────────────────────
  -- s    → jump anywhere on screen with 2 chars
  -- S    → treesitter-aware selection jump
  -- f/t  → enhanced f/t with labels
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = { enabled = true },   -- enhanced f/F/t/T
      },
    },
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash jump" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,             desc = "Remote flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<C-s>", mode = "c",               function() require("flash").toggle() end,             desc = "Toggle flash search" },
    },
  },

  -- ── Which-key (keybinding hints) ───────────────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        win = { border = "rounded" },
        layout = { align = "center" },
      })
      -- Register group labels so the popup is readable
      wk.add({
        { "<leader>s", group = "  splits" },
        { "<leader>r", group = "  replace" },
        { "<leader>v", group = "  vim/config" },
      })    end,
    },
    {
      "echasnovski/mini.icons",
      version = "*",
      lazy = true,
      config = function()
        require("mini.icons").setup()
      end,
    },
    -- ── Better text objects ────────────────────────────────────────────
    -- Adds: ii/ai (indent), iq/aq (quote), ia/aa (arg), ...
    {
      "echasnovski/mini.ai",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("mini.ai").setup({ n_lines = 500 })
      end,
    },

    -- ── Increment / decrement anything ────────────────────────────────
    -- <C-a>/<C-x> now work on true/false, yes/no, dates, hex, etc.
    {
      "monaqa/dial.nvim",
      keys = {
        { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end },
        { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end },
        { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end },
        { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end },
        { "<C-a>",  mode = "v", function() require("dial.map").manipulate("increment", "visual") end },
        { "<C-x>",  mode = "v", function() require("dial.map").manipulate("decrement", "visual") end },
      },
    },

  }
