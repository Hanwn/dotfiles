return {
	{
		"saghen/blink.cmp",
		optional = true,
		opts = {
			completion = {
				list = {
					selection = {
						preselect = false,
					},
				},
			},
			sources = {
				providers = {
					buffer = {
						min_keyword_length = 4,
					},
				},
			},
		},
	},
}
