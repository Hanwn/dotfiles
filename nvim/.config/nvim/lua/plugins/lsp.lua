return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		opts = {
			servers = {
				-- C/C++
				clangd = {},
				-- Python
				ty = {},
				-- Go
				gopls = {},
				-- Rust
				rust_analyzer = {},
				-- JS/TS/JSON
				vtsls = {},
				jsonls = {},
				-- Lua
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
			},
		},
	},
}
