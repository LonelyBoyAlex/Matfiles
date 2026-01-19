return{
   'nvim-lualine/lualine.nvim',
   config = function()
      require('lualine').setup {
         options = {
            --theme = 'base16',  -- Auto-syncs with base16 colorscheme
            theme = nil,  -- Auto-syncs with base16 colorscheme
            icons_enabled = true,
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },        
            --theme = 'dracula'
         }
      }
   end
}
