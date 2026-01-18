-- Insert mode: jj -> Esc
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("n", "gi", function()
	Snacks.picker.lsp_implementations({ picker = true })
end, { desc = "Go to implementations" })

vim.keymap.set("n", "gs", function()
	Snacks.picker.lsp_implementations({ picker = true })
end, { desc = "Go to super method" })

vim.keymap.set("n", "gt", function()
	Snacks.picker.lsp_type_definitions({ picker = true })
end)
