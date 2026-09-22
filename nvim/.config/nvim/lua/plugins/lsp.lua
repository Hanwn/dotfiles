return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		opts.inlay_hints = opts.inlay_hints or {}
		opts.inlay_hints.enabled = false
	end,
}
