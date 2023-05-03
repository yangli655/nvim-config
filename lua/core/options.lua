local opt = vim.opt

-- utf8
vim.g.encoding = "UTF-8"
opt.fileencoding = "utf-8"

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
opt.smartindent = true

-- 搜索大小写不敏感，除非包含大写
opt.ignorecase = true
opt.smartcase = true

-- 搜索不要高亮
opt.hlsearch = true
-- 边输入边搜索
opt.incsearch = true

-- 命令行高为 2，提供足够的显示空间
opt.cmdheight = 1

-- 当文件被外部程序修改时，自动加载
opt.autoread = true

-- 禁止折行
vim.wo.wrap = false

-- 鼠标支持
opt.mouse:append("a")

-- 禁止创建备份文件
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- split window 从下边和右边出现
opt.splitbelow = true
opt.splitright = true

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"

-- 样式
opt.termguicolors = true

-- 补全增强
opt.wildmenu = true

-- 补全最多显示10行
opt.pumheight = 10

-- 永远显示 tabline
opt.showtabline = 1

-- 使用增强状态栏插件后不再需要 vim 的模式提示
opt.showmode = false

-- 配置剪切板
opt.clipboard:append("unnamedplus")

-- 屏蔽 ruby perl healthcheck 报错
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
