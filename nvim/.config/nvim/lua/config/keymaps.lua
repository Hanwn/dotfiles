-- Insert mode: jj -> Esc
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- ignore default bookmark
vim.keymap.set("n", "m", "<Nop>", {desc="Disable native mark m"})
