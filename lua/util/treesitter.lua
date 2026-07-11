-- nvim-treesitter main branch 新 API
-- 参考: https://github.com/nvim-treesitter/nvim-treesitter (main branch)

-- 最小化 setup，只需指定安装目录（默认即可）
require("nvim-treesitter").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

-- 确保安装所需的 parser
local parsers = {
	"c",
	"cpp",
	"python",
	"yaml",
	"json",
	"lua",
	"rust",
	"markdown",
	"markdown_inline",
}

-- 异步安装（如果已安装则跳过）
require("nvim-treesitter").install(parsers)

-- FileType autocmd: 启用 treesitter highlight + indent
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
	callback = function()
		-- 仅对已安装 parser 的 filetype 启用 treesitter 高亮
		-- 使用 pcall 防止无 parser 的 filetype (如 alpha dashboard) 报错
		local ok = pcall(vim.treesitter.start)
		if ok then
			-- 启用 treesitter 缩进（实验性功能）
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
