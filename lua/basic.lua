-- utf8
vim.g.encoding = "UTF-8"
vim.o.fileencoding = "utf-8"

-- 设置光标所在的行号 相对行号
vim.wo.number = true
vim.wo.relativenumber = true

-- 移动时光标周围保留 3 行
vim.o.scrolloff = 3
vim.o.sidescrolloff = 3

-- 使用 Tab 键显示的空格数
vim.o.tabstop = 4
-- 缩进 4 个空格等于一个Tab
vim.o.softtabstop = 4
-- 缩进的字符数量
vim.o.shiftwidth = 4
vim.o.shiftround = true

-- 空格替代tab
vim.o.expandtab = true

-- 新行对齐当前行
vim.o.autoindent = true
vim.o.smartindent = true

-- 搜索大小写不敏感，除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true

-- 搜索不要高亮
vim.o.hlsearch = true
-- 边输入边搜索
vim.o.incsearch = true

-- 命令行高为 2，提供足够的显示空间
vim.o.cmdheight = 1

-- 当文件被外部程序修改时，自动加载
vim.o.autoread = true

-- 禁止折行
vim.wo.wrap = false

-- 鼠标支持
vim.o.mouse = "a"

-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- split window 从下边和右边出现
vim.o.splitbelow = true
vim.o.splitright = true

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"

-- 样式
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- 补全增强
vim.o.wildmenu = true

-- 补全最多显示10行
vim.o.pumheight = 10

-- 永远显示 tabline
vim.o.showtabline = 1

-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false

-- 配置剪切板
vim.o.clipboard = "unnamedplus"

