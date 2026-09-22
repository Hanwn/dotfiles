return {
	"hanwn/spelunk.nvim",
	branch = "fix/snacks-split-actions",
	event = "VeryLazy",
	dependencies = {
		"folke/snacks.nvim", -- Optional: for enhanced fuzzy search capabilities
		"nvim-treesitter/nvim-treesitter", -- Optional: for showing grammar context
	},
	opts = {
		enable_persist = true,
		base_mappings = {
			-- Toggle the UI open/closed
			toggle = "<leader>mt",
			-- Add a bookmark to the current stack
			add = "<leader>ma",
			-- Delete current line's bookmark from the current stack
			delete = "<leader>md",
			-- Move to the next bookmark in the stack
			next_bookmark = "<leader>mn",
			-- Move to the previous bookmark in the stack
			prev_bookmark = "<leader>mp",
			-- Fuzzy-find all bookmarks
			-- search_bookmarks = "<leader>sm",
			-- Fuzzy-find bookmarks in current stack
			search_current_bookmarks = "<leader>sm",
			-- Fuzzy find all stacks
			-- search_stacks = "<leader>bs",
			-- Change line of hovered bookmark
			change_line = "<leader>mc",
		},
		window_mappings = {
			goto_bookmark_hsplit = "<C-s>",
			goto_bookmark_vsplit = "<C-v>",
		},
		cursor_character = ">",
		fuzzy_search_provider = "snacks",
		enable_status_col_display = true,
	},
}
