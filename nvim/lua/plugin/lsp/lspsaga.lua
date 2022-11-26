-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
	return
end

saga.init_lsp_saga({
	-- keybinds for navigation in lspsaga window
	move_in_saga = { prev = "<C-k>", next = "<C-j>" },
	-- use enter to open file with finder
	finder_action_keys = {
		open = "<CR>",
	},
	-- use enter to open file with definition preview
	definition_action_keys = {
		quit = "<ESC>",
		edit = "<CR>",
	},
	-- current line position, like vscode or jetbrains
	symbol_in_winbar = {
		in_custom = false,
		enable = true,
		separator = " ",
		show_file = true,
		-- define how to customize filename, eg: %:., %
		-- if not set, use default value `%:t`
		-- more information see `vim.fn.expand` or `expand`
		-- ## only valid after set `show_file = true`
		file_formatter = "",
		click_support = false,
	},

	-- show outline
	show_outline = {
		win_position = "right",
		--set special filetype win that outline window split.like NvimTree neotree
		-- defx, db_ui
		win_with = "",
		win_width = 30,
		auto_enter = true,
		auto_preview = true,
		virt_text = "┃",
		jump_key = "o",
		-- auto refresh when change buffer
		auto_refresh = true,
	},

	rename_action_quit = "<ESC>",
	code_action_keys = {
		quit = "<ESC>",
		exec = "<CR>",
	},
})

local keymap = vim.keymap.set
keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })
keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true })
keymap("n", "<leader>k", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
keymap("n", "<leader>v", ":LSoutlineToggle<CR>", { noremap = true, silent = true })
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

-- Only jump to error
keymap("n", "[E", function()
	require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
keymap("n", "]E", function()
	require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { silent = true })
-- Diagnsotic jump can use `<c-o>` to jump back
