return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.options.section_separators = { left = "", right = "" }
		opts.options.component_separators = { left = "", right = "" }
		opts.sections.lualine_z = {
			{
				require("opencode").statusline,
			},
		}
		opts.options.theme = "everforest"
	end,
}
