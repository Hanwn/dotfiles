return {
	"dmtrKovalenko/fff.nvim",
	lazy = false,
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		layout = {
			prompt_position = "top",
		},
		debug = {
			show_scores = true,
		},
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("fff").find_files()
			end,
			desc = "Find files (fff)",
		},
		{
			"<leader>sg",
			function()
				require("fff").live_grep()
			end,
			desc = "LiFFFe grep",
		},
		{
			"<leader>fz",
			function()
				require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
			end,
			desc = "Live fffuzy grep",
		},
		{
			"<leader>fc",
			function()
				require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			end,
			desc = "Search current word",
		},
	},
}
