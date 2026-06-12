return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			go = { "gofumpt", "goimports" },
			lua = { "stylua" },
			rust = { "rustfmt" },
			python = { "ruff_fix", "ruff_format" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		formatters = {
			prettier = {
				options = {
					tab_width = 2,
					use_tabs = false,
				},
			},
			ruff_format = {
				options = {
					indent_width = 2,
				},
			},
		},
	},
}
