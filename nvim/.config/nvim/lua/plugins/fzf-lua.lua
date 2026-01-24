return {
	{
		"ibhagwan/fzf-lua",
		keys = {
			{
				"gi",
				function()
					require("fzf-lua").lsp_implementations({
						jump_to_single_result = false,
					})
				end,
				desc = "LSP: Go to implementations (fzf)",
			},
			{
				"gs",
				function()
					require("fzf-lua").lsp_implementations({
						jump_to_single_result = false,
					})
				end,
				desc = "LSP: Go to implementations (fzf)",
			},
			{
				"gt",
				function()
					require("fzf-lua").lsp_typedefs({
						jump_to_single_result = false,
					})
				end,
				desc = "LSP: Go to type definitions (fzf)",
			},
		},
	},
}
