return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				-- LSP
				"clangd",
				"ty",
				"gopls",
				"rust-analyzer",
				"json-lsp",
				"lua-language-server",
				"oxlint",
				-- Formatter
				"stylua",
				"ruff",
				"oxfmt",
				"gofumpt",
				"clang-format",
			},
		},
	},
}
