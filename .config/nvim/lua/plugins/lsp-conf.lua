return {
  -- Mason
  { "mason-org/mason.nvim", opts = {} },

  -- Mason LSP bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "ts_ls" },
      automatic_installation = true,
    },
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason-lspconfig.nvim" },
    config = function()
      -- Custom lua_ls settings
      vim.lsp.config.lua_ls = vim.lsp.config.lua_ls or {}
      vim.lsp.config.lua_ls.settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      }
      
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client_id = ev.data and ev.data.client_id
          local client = client_id and vim.lsp.get_client_by_id(client_id)
          --print("LSP attached: " .. (client and client.name or "unknown"))
          
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>L", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
}

