return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.inlay_hints = opts.inlay_hints or {}
		opts.inlay_hints.enabled = false
		opts.servers = opts.servers or {}
		opts.servers.pyright = {}
		opts.servers.ty = { enabled = false }
	end,
}
