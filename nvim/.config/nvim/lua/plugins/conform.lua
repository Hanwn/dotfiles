return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format" },
			go = { "gofumpt" },
			rust = { "rustfmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			typescript = { "oxfmt" },
			typescriptreact = { "oxfmt" },
		},
	},
}
