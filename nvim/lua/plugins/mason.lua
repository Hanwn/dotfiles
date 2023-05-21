return {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
	require("mason").setup({
		-- list of servers for mason to install
		ensure_installed = {
			"gopls",
			"clangd",
			"rust_analyzer",
			-- "neocmake",
			"cmake",
			"tsserver",
			"pyright",
			"quick_lint_js",
		},
		-- auto-install configured servers (with lspconfig)
		automatic_installation = true, -- not the same as ensure_installed
	})
    end
}
