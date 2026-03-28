return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			go = { "gofumpt", "goimports" },
			lua = { "stylua" },
			rust = {},
			python = { "ruff_fix", "ruff_format" },
			sh = { "shfmt" },
			yaml = { "yamlfmt" },
			toml = { "taplo" },
			typst = { "prettypst" },
		},
		formatters = {
		  prettier = {
		    options = {
		      tab_width = 4,
		      use_tabs = false,
		    },
		  },
			ruff_format = {
				options = {
					indent_width = 4,
				},
			},
			shfmt = {
				options = {
					indent = 2,
				},
			},
		},
	},
}
