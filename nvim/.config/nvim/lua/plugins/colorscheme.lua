return {
	-- add gruvbox
	{ "folke/tokyonight.nvim", "catppuccin/nvim", "olimorris/onedarkpro.nvim" },

	-- Configure LazyVim to load gruvbox
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight-night",
		},
	},
}
