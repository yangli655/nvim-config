syntax on
set number "设置行号
set relativenumber "设置光标所在的行号 相对行号
set ruler "状态栏中会显示当前的光标所在位置
set laststatus=2 "是否显示状态栏 0=不显示 1=在多个窗口时显示 2=显示
set cursorline "高亮当前光标所在位置
set ruler "显示标尺

" 启用自动对齐功能，把上一行的对齐格式应用到下一行
set autoindent
" 依据上面的格式，智能的选择对齐方式，对于类似C语言编写很有用处
set smartindent

"wrap
set wrap "自动换行
set linebreak "不会在单词内部折行
set scrolloff=3 "滚屏时，光标所处顶部/底部的距离 3为3行

"About search
set hlsearch "高亮显示搜索的结果
set incsearch "每次输入一个字符都会自动匹配

"tabs
set tabstop=4 "使用 Tab 键，显示的空格数
set shiftwidth=4 "缩进的字符数量
set expandtab "自动将Tab转为空格
set softtabstop=4 "Tab 转化空格的数量
set autoindent "自动与上一行缩进保持一致

"filetype
filetype on "开启文件类型检测
filetype plugin on "允许加载文件类型插件
filetype indent on "定义不同文件类型的缩进格式
" 文件缩进及tab个数
au FileType html,python,vim,javascript setl shiftwidth=4
au FileType html,python,vim,javascript setl tabstop=4
au FileType java,php setl shiftwidth=4
au FileType java,php setl tabstop=4

" 显示匹配的括号
set showmatch
" 去掉输入错误提示声音
set noeb
" 自动保存
set autowrite
" 突出显示当前行 
set cursorline
" 突出显示当前列
set cursorcolumn
" 共享剪贴板
set clipboard+=unnamed
" 文件被改动时自动载入
set autoread

" C风格缩进
set cindent
set completeopt=longest,menu

"window
"set splitbelow "让新开的窗口出现在下方
set splitright "让新开的窗口出现在右方

imap jk <ESC>
nnoremap tn  :tabnew<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tc  :tabclose<CR>

nnoremap bn :bnext<CR>
nnoremap bp :bprev<CR>
nnoremap bd :bdelete<CR>


" 状态行显示的内容
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

" 启动显示状态行1，总是显示状态行2
set laststatus=2
