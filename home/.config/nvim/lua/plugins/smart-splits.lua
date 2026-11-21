return {
	"smart-splits-nvim/smart-splits.nvim",
	version = "^3.0.0",
	lazy = false,
	opts = {
		move = { at_edge = "stop" },
		mux = {
			warn_if_unusable = false,
			backend = {
				"smart-splits-backend-herdr",
				"smart-splits-backend-tmux",
			},
		},
	},
	dependencies = {
		{
			"adriankarlen/smart-splits-backend-herdr",
			main = "smart-splits-backend-herdr",
			opts = {},
		},
		{
			"smart-splits-nvim/backend-tmux",
			main = "smart-splits-backend-tmux",
			opts = {
				disable_nav_when_zoomed = true,
			},
		},
	},
	keys = {
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
			desc = "Navigate left",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			desc = "Navigate down",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			desc = "Navigate up",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			desc = "Navigate right",
		},
		{
			"<M-h>",
			function()
				require("smart-splits").resize_left()
			end,
			desc = "Resize left",
		},
		{
			"<M-j>",
			function()
				require("smart-splits").resize_down()
			end,
			desc = "Resize down",
		},
		{
			"<M-k>",
			function()
				require("smart-splits").resize_up()
			end,
			desc = "Resize up",
		},
		{
			"<M-l>",
			function()
				require("smart-splits").resize_right()
			end,
			desc = "Resize right",
		},
	},
}
