return {
	"nvim-neo-tree/neo-tree.nvim",
	--branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
   require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					visible = true, -- Show hidden files
					hide_dotfiles = false, -- Don't hide dotfiles (.* files)
					hide_gitignored = true, -- Optionally show gitignored files
	        always_show = { ".config"},
        },
			},
		})

		-- Keybindings 
		vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", {})
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal float<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
	end,
}
