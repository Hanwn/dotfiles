return {
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			-- Prettier keeps short JSON objects on one line; jq expands them consistently.
			opts.formatters_by_ft.json = { "jq", "prettier", stop_after_first = true }
		end,
	}
}
