return {
   -- directory traverser
   "nvim-neo-tree/neo-tree.nvim",
   branch = "v3.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", 
   },
   lazy = false, -- loads immediately despite comment
   config = function()
      vim.keymap.set('n', '<leader>b', ':Neotree filesystem reveal left<CR>')
      vim.keymap.set('n', '<leader>e', ':Neotree focus position=right<CR>')  
      vim.keymap.set('n', '<leader>q', ':Neotree close<CR>')  
      require("neo-tree").setup({
         close_if_last_wiindow = true,
         default_component_configs = {
            container = {
               enable_character_fade = true,
            },
            indent = {
               indent_size = 2,
               padding = 1,
               with_markers = true,
               indent_marker = "│",
               last_indent_marker = "└",
               highlight = "NeoTreeIndentMarker",
               with_expanders = nil,
               expander_collapsed = "",
               expander_expanded = "",
               expander_highlight = "NeoTreeExpander",
            },
            icon = {
               folder_closed = "",
               folder_open = "",
               folder_empty = "󰜌",
               provider = function(icon, node, state)
                  if node.type == "file" or node.type == "terminal" then
                     local success, web_devicons = pcall(require, "nvim-web-devicons")
                     local name = node.type == "terminal" and "terminal" or node.name
                     if success then
                        local devicon, hl = web_devicons.get_icon(name)
                        icon.text = devicon or icon.text
                        icon.highlight = hl or icon.highlight
                     end
                  end
               end,
               default = "*",
               highlight = "NeoTreeFileIcon",
               use_filtered_colors = true,
            },
            modified = {
               symbol = "[+]",
               highlight = "NeoTreeModified",
            },
         },
         filesystem = {
            filtered_items = {
               visible = true,
               hide_dotfiles = false,
               hide_gitignored = true,
               hide_ignored = true,
               ignore_files = {
                  ".neotreeignore",
                  ".ignore",
               },
               hide_hidden = false,
               hide_by_name = {},
               hide_by_pattern = {},
               always_show = {},
               always_show_by_pattern = {},
               never_show = {},
               never_show_by_pattern = {},
            },
            follow_current_file = {
               enabled = true,
               leave_dirs_open = false,
            }
         }
      })
   end
}

