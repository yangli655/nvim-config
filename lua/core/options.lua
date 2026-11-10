local opt = vim.opt

-- 设置光标所在的行号 相对行号
opt.number = true
opt.relativenumber = true

-- 移动时光标周围保留 3 行
opt.scrolloff = 3
opt.sidescrolloff = 3

-- 使用 Tab 键显示的空格数
opt.tabstop = 4
-- 缩进 4 个空格等于一个Tab
opt.softtabstop = 4
-- 缩进的字符数量
opt.shiftwidth = 4
opt.shiftround = true

-- 空格替代tab
opt.expandtab = true

-- 新行对齐当前行
opt.autoindent = true

-- 搜索大小写不敏感，除非包含大写
opt.ignorecase = true
opt.smartcase = true

-- 搜索不要高亮
opt.hlsearch = false
-- 边输入边搜索
opt.incsearch = true

-- 命令行高为 2，提供足够的显示空间
opt.cmdheight = 1

-- 当文件被外部程序修改时，自动加载
opt.autoread = true

-- 禁止折行
opt.wrap = false

-- 鼠标支持
opt.mouse = "a"

-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- split window 从下边和右边出现
opt.splitbelow = true
opt.splitright = true

-- 样式
opt.termguicolors = true

-- 补全最多显示10行
opt.pumheight = 10

-- 永远显示 tabline
opt.showtabline = 2

-- 使用增强状态栏插件后不再需要 vim 的模式提示
opt.showmode = false

-- 配置剪切板
opt.clipboard:append("unnamedplus")

-- disable virtual text
vim.diagnostic.config({
	virtual_text = false,
})

-- 屏蔽 ruby perl healthcheck 报错
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- 自动补全不自动选中
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }

-- persistence.nvim 存会话用的就是原生 :mksession，存什么由 'sessionoptions' 决定。
-- 在默认值之外补了 winpos（窗口位置）和 localoptions（窗口/缓冲区局部选项与映射，
-- 不含局部选项的全局值）；folds 本身已经会带上局部 fold 选项。
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- 折叠配置：优先 LSP 折叠；当前 buffer 没有支持 foldingRange 的 LSP 时
-- 回退到 treesitter。直接用 vim.lsp.foldexpr() 会在无 LSP 时返回 "0"，
-- 并不会自动使用 treesitter，所以需要自己包一层判断。
opt.foldmethod = "expr"
opt.foldlevel = 99
opt.foldenable = false

_G.nvim_foldexpr = function()
	if vim.b.fold_lsp_ready then
		return vim.lsp.foldexpr()
	end
	local ok, ts = pcall(vim.treesitter.foldexpr)
	if ok then
		return ts
	end
	return "0"
end
opt.foldexpr = "v:lua.nvim_foldexpr()"

local lsp_fold_group = vim.api.nvim_create_augroup("LspFoldDetect", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_fold_group,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/foldingRange") then
			vim.b[ev.buf].fold_lsp_ready = true
		end
	end,
})
-- LSP 退出/崩溃后要退回 treesitter，否则 foldexpr 会一直拿到 LSP 的 "0"。
-- LspDetach 触发时 get_clients() 还能看到正在退出的 client，必须 schedule 到下一拍
-- 并排除 ev.data.client_id，否则 lua_ls 停掉后 fold_lsp_ready 会一直卡在 true。
vim.api.nvim_create_autocmd("LspDetach", {
	group = lsp_fold_group,
	callback = function(ev)
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(ev.buf) then
				return
			end
			local has_fold_client = false
			for _, client in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
				if client.id ~= ev.data.client_id and client:supports_method("textDocument/foldingRange") then
					has_fold_client = true
					break
				end
			end
			vim.b[ev.buf].fold_lsp_ready = has_fold_client or nil
		end)
	end,
})

-- 持久化 undo：关闭文件后仍能撤销
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- 光标位置恢复：打开文件时跳转到上次编辑位置
local cursor_group = vim.api.nvim_create_augroup("CursorRestore", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = cursor_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})
