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
				"vtsls",
				"json-lsp",
				"lua-language-server",
				-- Formatter
				"stylua",
				"ruff",
				"prettier",
				"gofumpt",
				"clang-format",
			},
		},
	},
}
