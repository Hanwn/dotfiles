return {
	{
		"neovim/nvim-lspconfig",
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
				oxlint = {},
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
