return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>b"] = { name = "+buffers" },
        ["<leader>d"] = { name = "+delete" },
        ["<leader>f"] = { name = "+find & files" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>s"] = { name = "+search & replace" },
        ["<leader>t"] = { name = "+tabs/windows/tmux" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- <leader>d = close buffer (smart)
      wk.add {
        mode = { "n", "x" },
        { "<leader>d", function()
            if vim.fn.len(vim.fn.getbufinfo({buflisted = 1})) > 1 then
              vim.cmd("bd")
            else
              vim.cmd("q")
            end
          end, 
          desc = "Close buffer", 
          name = "Close buffer (smart)" 
        },
      }
    end,
  },
}

