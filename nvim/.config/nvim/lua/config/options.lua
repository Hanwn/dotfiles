local opt = vim.opt

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

vim.g.lazyvim_picker = "fzf"

-- 禁用未使用的 language providers，加快启动并消除 checkhealth 警告
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- 设置光标形状：所有模式都使用 block
vim.opt.guicursor = {
	"n-v-c-sm:block", -- 普通、可视、命令行、选择模式使用 block
	"i-ci-ve:block", -- 插入、CI、可视模式使用 block
	"r-cr-o:hor20", -- 替换、CR、操作符模式使用水平条
}
