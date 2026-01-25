return {
   -- text highlighting
   'nvim-treesitter/nvim-treesitter',
   lazy = false,
   build = ':TSUpdate',
   config = function()
      opts = {
         ensure_installed = {"lua", "css"},
         sync_install = true,
         highlight = {enable = true},  
         indent = {enable = true}     
      }
   end
}

