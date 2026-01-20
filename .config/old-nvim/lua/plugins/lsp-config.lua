return {
  {
    -- Mason for managing LSP servers
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup(
      {
            ui = {
                border = "rounded"
            }
        })
    end,
  },
  {
    -- Mason LSP config integration
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true, -- Automatically install LSP servers that are needed
    },
  },
  {
    -- nvim-lspconfig for configuring LSP servers
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- 1. Get default capabilities for cmp
      local defaults = require('cmp_nvim_lsp').default_capabilities()

      -- 2. Define the list of servers you want to enable
      -- (I consolidated your two ts_ls entries into one)
      local servers = {
        "ts_ls",
        "solargraph",
        "html",
        "cssls",
        "lua_ls",
      }

      -- 3. Loop through standard servers and enable them
      for _, server in ipairs(servers) do
        vim.lsp.config[server] = { capabilities = defaults }
        vim.lsp.enable(server)
      end

      -- 4. Manual setup for servers with specific overrides (qmlls)
      vim.lsp.config["qmlls"] = {
        capabilities = defaults,
        cmd = { "qmlls", "-E" },
      }
      vim.lsp.enable("qmlls")

      -- 5. Keybindings
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}

