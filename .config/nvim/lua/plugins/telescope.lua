return{
   --finding files and fuzzzy find
   'nvim-telescope/telescope.nvim',
   dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
   },
   config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n','<leader>ff', builtin.find_files,{}) 
      vim.keymap.set('n','<leader>fg', builtin.live_grep,{}) 
      vim.keymap.set('n','<leader>o', builtin.oldfiles,{}) 
   end
}

