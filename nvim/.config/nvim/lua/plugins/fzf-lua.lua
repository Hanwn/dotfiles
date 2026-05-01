return {
	{
		"ibhagwan/fzf-lua",
		opts = {
			rg_glob = true,
			grep = {
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -e",
			},
		},

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
