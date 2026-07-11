# Neovim 配置文档

> 最后更新: 2026-07-11
> Neovim 版本要求: 0.10+

## 目录

- [1. 概览](#1-概览)
- [2. 基础设置](#2-基础设置)
- [3. 插件列表](#3-插件列表)
- [4. 快捷键映射](#4-快捷键映射)
- [5. LSP 配置](#5-lsp-配置)
- [6. 主题](#6-主题)
- [7. 文件结构](#7-文件结构)

---

## 1. 概览

本配置使用 [lazy.nvim](https://github.com/folke/lazy.nvim) 作为插件管理器，采用模块化设计，主要分为以下几个部分：

| 模块 | 说明 |
|-----|------|
| UI | 界面相关（主题、状态栏、标签栏、文件浏览器） |
| Utils | 工具类（Telescope、Treesitter、GitSigns） |
| LSP | 语言服务器协议（补全、诊断、格式化） |
| Core | 核心配置（选项、快捷键） |

### Leader 键

| 键 | 用途 |
|----|------|
| `<Space>` | 全局 Leader 键 |
| `\` | 本地 Leader 键 |

---

## 2. 基础设置

### 编辑器选项 (`lua/core/options.lua`)

| 选项 | 值 | 说明 |
|-----|-----|------|
| `encoding` | UTF-8 | 文件编码 |
| `number` | true | 显示行号 |
| `relativenumber` | true | 相对行号 |
| `scrolloff` | 3 | 光标上下保留行数 |
| `tabstop` | 4 | Tab 显示宽度 |
| `shiftwidth` | 4 | 缩进宽度 |
| `expandtab` | true | 空格替代 Tab |
| `autoindent` | true | 自动缩进 |
| `ignorecase` | true | 搜索忽略大小写 |
| `smartcase` | true | 智能大小写 |
| `hlsearch` | false | 不高亮搜索结果 |
| `incsearch` | true | 边输入边搜索 |
| `wrap` | false | 不折行 |
| `mouse` | a | 启用鼠标 |
| `clipboard` | unnamedplus | 使用系统剪贴板 |
| `splitbelow` | true | 水平分割在下方 |
| `splitright` | true | 垂直分割在右侧 |
| `termguicolors` | true | 启用真彩色 |
| `foldmethod` | expr | 折叠方式 |
| `foldexpr` | vim.lsp.foldexpr() | LSP 折叠表达式 |
| `foldenable` | false | 默认不折叠 |

### 诊断配置

```lua
vim.diagnostic.config({
    virtual_text = false,  -- 禁用行内虚拟文本
})
```

---

## 3. 插件列表

### 3.1 UI 插件

#### snacks.nvim
- **仓库**: `folke/snacks.nvim`
- **功能**: 现代化 Neovim 增强工具集

**启用的功能**:

| 功能 | 说明 |
|-----|------|
| `dashboard` | 启动界面 |
| `terminal` | 浮动终端 |
| `words` | 自动高亮当前单词 |
| `bigfile` | 大文件优化 |
| `scroll` | 平滑滚动动画 |
| `explorer` | 文件浏览器 |

**禁用的功能**: image, input, lazygit, notifier, picker, quickfile, scope, statuscolumn, toggle

**Dashboard 快捷键**:

| 按键 | 功能 |
|-----|------|
| `f` | 查找文件 |
| `n` | 新建文件 |
| `g` | 搜索文本 |
| `r` | 最近文件 |
| `c` | 编辑配置 |
| `s` | 恢复会话 |
| `L` | Lazy 插件管理 |
| `q` | 退出 |

**Explorer 快捷键**:

| 按键 | 功能 |
|-----|------|
| `<CR>` | 打开文件 |
| `<C-v>` | 垂直分割打开 |
| `<C-x>` | 水平分割打开 |
| `a` | 新建文件/目录 |
| `d` | 删除 |
| `r` | 重命名 |
| `c` | 复制 |
| `x` | 剪切 |
| `p` | 粘贴 |
| `y` | 复制文件名 |
| `Y` | 复制路径 |
| `gy` | 复制绝对路径 |
| `.` | 切换隐藏文件 |
| `<C-]>` | 进入目录 |
| `<BS>` | 上级目录 |

---

#### tokyonight.nvim
- **仓库**: `folke/tokyonight.nvim`
- **功能**: 现代主题
- **使用样式**: `tokyonight-night`

---

#### lualine.nvim
- **仓库**: `nvim-lualine/lualine.nvim`
- **功能**: 状态栏
- **配置**: 使用自定义 eviline 配置 (`lua/ui/lualine.lua`)

**显示内容**:
- 左侧: 模式图标 | 文件大小 | 文件名 | 位置 | 进度 | 诊断
- 右侧: 编码 | 文件格式 | Git 分支 | Diff | LSP 状态

---

#### bufferline.nvim
- **仓库**: `akinsho/bufferline.nvim`
- **功能**: 标签栏/buffer 管理

**配置**:
- 显示 buffer 序号
- LSP 诊断指示器
- 与 snacks explorer 集成

---

#### nvim-surround
- **仓库**: `kylechui/nvim-surround`
- **功能**:  surrounds 文本操作

| 操作 | 快捷键 | 示例 |
|-----|-------|------|
| 添加包围 | `ys{motion}{char}` | `ysiw)` → `(word)` |
| 删除包围 | `ds{char}` | `ds]` → 删除 `[]` |
| 替换包围 | `cs{old}{new}` | `cs'"` → `'` 换为 `"` |
| 删除 HTML 标签 | `dst` | 删除 `<b></b>` |
| 替换 HTML 标签 | `csth1<CR>` | `<b>` → `<h1>` |

---

### 3.2 工具插件

#### telescope.nvim
- **仓库**: `nvim-telescope/telescope.nvim`
- **依赖**: `plenary.nvim`, `telescope-fzf-native.nvim`
- **功能**: 模糊搜索

**配置**:
- 启用 fzf 原生排序
- 智能大小写匹配

---

#### nvim-treesitter
- **仓库**: `nvim-treesitter/nvim-treesitter` (main 分支)
- **功能**: 语法高亮、折叠、缩进

**安装的 Parser**:
- c, cpp, python, yaml, json, lua, rust, markdown, markdown_inline

---

#### gitsigns.nvim
- **仓库**: `lewis6991/gitsigns.nvim`
- **功能**: Git 状态显示和操作

---

#### hardtime.nvim
- **仓库**: `m4xshen/hardtime.nvim`
- **功能**: 防止低效按键习惯（如连续按 j/k）

---

#### mini.pairs
- **仓库**: `echasnovski/mini.pairs`
- **功能**: 自动配对括号、引号等
- **特点**: 纯 Lua，无需编译

---

#### blink.indent
- **仓库**: `saghen/blink.indent`
- **功能**: 缩进引导线

**配置**:
- 使用 `▎` 字符
- 彩虹色缩进: 橙、紫、蓝
- 作用域高亮

**快捷键**:

| 按键 | 功能 |
|-----|------|
| `[i` | 跳转到作用域顶部 |
| `]i` | 跳转到作用域底部 |
| `ii` | 文本对象：作用域内 |
| `ai` | 文本对象：作用域含边界 |

---

### 3.3 LSP 插件

#### mason.nvim + mason-lspconfig.nvim
- **仓库**: `mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim`
- **功能**: LSP 服务器管理

**自动安装的 LSP**:
- `lua_ls` - Lua
- `bashls` - Bash
- `clangd` - C/C++
- `pyright` - Python
- `yamlls` - YAML
- `jsonls` - JSON

---

#### blink.cmp
- **仓库**: `saghen/blink.cmp`
- **功能**: 代码补全
- **特点**: Rust 实现的模糊匹配

**补全源**:
1. LSP
2. 路径
3. 代码片段
4. Buffer

**快捷键**:

| 按键 | 功能 |
|-----|------|
| `<C-Space>` | 打开补全菜单 |
| `<C-n>` / `<Down>` | 下一项 |
| `<C-p>` / `<Up>` | 上一项 |
| `<C-e>` | 关闭菜单 |
| `<C-k>` | 切换签名帮助 |
| `<CR>` | 接受补全 |

---

#### trouble.nvim
- **仓库**: `folke/trouble.nvim`
- **功能**: 诊断/符号列表

---

#### conform.nvim
- **仓库**: `stevearc/conform.nvim`
- **功能**: 代码格式化

**格式化器配置**:

| 语言 | 格式化器 |
|-----|---------|
| Lua | stylua |
| Python | ruff_format (fallback: isort + black) |
| Bash | shfmt |
| C/C++ | clang-format |
| YAML | yamlfmt |
| JSON | jq |

**保存时自动格式化**:
- 超时: 500ms
- 回退到 LSP 格式化

---

#### auto-session
- **仓库**: `rmagatti/auto-session`
- **功能**: 自动会话管理

**配置**:
- 自动保存/恢复会话
- Git 分支切换时自动恢复
- 忽略目录: `~/`, `~/Projects`, `~/Downloads`, `/`

---

## 4. 快捷键映射

### 4.1 通用快捷键 (`lua/core/keymaps.lua`)

#### Insert 模式

| 按键 | 功能 |
|-----|------|
| `jk` | 退出 Insert 模式 |
| `<up>` | 禁用 |
| `<down>` | 禁用 |
| `<left>` | 禁用 |
| `<right>` | 禁用 |

#### Normal 模式

**窗口导航**:

| 按键 | 功能 |
|-----|------|
| `<C-h>` | 左窗口 |
| `<C-j>` | 下窗口 |
| `<C-k>` | 上窗口 |
| `<C-l>` | 右窗口 |

**禁用方向键**: `<up>`, `<down>`, `<left>`, `<right>`

**Buffer 操作**:

| 按键 | 功能 |
|-----|------|
| `bn` | 下一个 buffer |
| `bp` | 上一个 buffer |
| `bd` | 关闭 buffer |

**Tab 操作**:

| 按键 | 功能 |
|-----|------|
| `tn` | 新建 Tab |
| `tj` | 下一个 Tab |
| `tk` | 上一个 Tab |
| `tc` | 关闭 Tab |

**BufferLine**:

| 按键 | 功能 |
|-----|------|
| `bh` | Buffer Pick（快速跳转） |
| `bH` | Buffer Pick Close（快速关闭） |

**浮动终端**:

| 按键 | 功能 |
|-----|------|
| `<C-\>` | 打开/关闭浮动终端 (Normal 和 Terminal 模式) |

---

### 4.2 Telescope 快捷键

| 按键 | 功能 |
|-----|------|
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 搜索文本 (live grep) |
| `<leader>fb` | 查找 Buffer |
| `<leader>fh` | 查找帮助文档 |

---

### 4.3 Snacks 快捷键

| 按键 | 功能 |
|-----|------|
| `<leader>;` | 打开 Dashboard |
| `<leader>e` | 打开文件浏览器 |

---

### 4.4 Trouble 快捷键

| 按键 | 功能 |
|-----|------|
| `<leader>xx` | 全局诊断列表 |
| `<leader>xX` | 当前 Buffer 诊断列表 |
| `<leader>cs` | 符号列表 |

---

## 5. LSP 配置

### 5.1 LSP 快捷键 (`lua/lsp/keymaps.lua`)

所有 LSP 快捷键在 LSP 附加到 buffer 时自动设置。

#### 导航

| 按键 | 功能 |
|-----|------|
| `gh` | LSP Finder (查找定义) |
| `gd` | 跳转到定义 |
| `gp` | 预览定义 (Peek) |
| `gt` | 跳转到类型定义 |
| `gR` | 查找引用 |
| `gI` | 跳转到实现 |

#### 操作

| 按键 | 功能 |
|-----|------|
| `gr` | 重命名符号 |
| `<leader>ca` | 代码操作 (Normal/Visual) |
| `K` | 悬停文档 |

#### 诊断

| 按键 | 功能 |
|-----|------|
| `[e` | 上一个诊断 |
| `]e` | 下一个诊断 |
| `[E` | 上一个错误 |
| `]E` | 下一个错误 |
| `<leader>sl` | 显示行诊断 |
| `<leader>sb` | 显示 Buffer 诊断 |
| `<leader>sw` | 显示工作区诊断 (Trouble) |
| `<leader>sc` | 显示光标诊断 |

#### 代码结构

| 按键 | 功能 |
|-----|------|
| `<leader>o` | 符号大纲 (Trouble) |
| `<leader>ci` | 入向调用 |
| `<leader>co` | 出向调用 |

---

### 5.2 GitSigns 快捷键 (`lua/util/gitsigns.lua`)

#### 导航

| 按键 | 功能 |
|-----|------|
| `]c` | 下一个 Git 更改 |
| `[c` | 上一个 Git 更改 |

#### Hunk 操作

| 按键 | 功能 |
|-----|------|
| `<leader>hs` | Stage Hunk |
| `<leader>hr` | Reset Hunk |
| `<leader>hS` | Stage Buffer |
| `<leader>hR` | Reset Buffer |
| `<leader>hp` | 预览 Hunk |
| `<leader>hi` | 内联预览 Hunk |
| `<leader>hb` | Blame 行 |
| `<leader>hd` | Diff This |
| `<leader>hD` | Diff This (~) |

#### 列表

| 按键 | 功能 |
|-----|------|
| `<leader>hQ` | Quickfix List (all) |
| `<leader>hq` | Quickfix List |

#### 切换

| 按键 | 功能 |
|-----|------|
| `<leader>tb` | 切换行内 Blame |
| `<leader>tw` | 切换 Word Diff |

#### 文本对象

| 按键 | 功能 |
|-----|------|
| `ih` | Hunk 内部 (Operator-pending/Visual) |

---

## 6. 主题

### tokyonight

- **样式**: `tokyonight-night`
- **特点**: 蓝紫色调，现代感强

---

## 7. 文件结构

```
~/.config/nvim/
├── init.lua                    # 入口文件
├── lazy-lock.json              # 插件版本锁定
├── lua/
│   ├── core/
│   │   ├── keymaps.lua         # 全局快捷键
│   │   └── options.lua         # 编辑器选项
│   ├── ui/
│   │   ├── bufferline.lua      # 标签栏配置
│   │   └── lualine.lua         # 状态栏配置
│   ├── util/
│   │   ├── gitsigns.lua        # Git 状态配置
│   │   ├── telescope.lua       # Telescope 配置
│   │   └── treesitter.lua      # Treesitter 配置
│   ├── lsp/
│   │   ├── keymaps.lua         # LSP 快捷键
│   │   ├── lsp.lua             # LSP 配置
│   │   └── mason.lua           # Mason 配置
│   └── lazy-nvim.lua           # Lazy.nvim 插件配置
```

---

## 附录: 插件依赖图

```
snacks.nvim
├── dashboard
├── terminal
├── words
├── bigfile
├── scroll
└── explorer

LSP 生态
├── mason.nvim          (LSP 服务器安装)
├── mason-lspconfig     (LSP 自动配置)
├── nvim-lspconfig      (LSP 配置)
├── blink.cmp           (代码补全)
├── trouble.nvim        (诊断列表)
└── conform.nvim        (代码格式化)

编辑增强
├── nvim-treesitter     (语法高亮)
├── nvim-surround       (surrounds 操作)
├── mini.pairs          (自动配对)
├── blink.indent        (缩进引导)
└── hardtime.nvim       (防止低效按键)

搜索 & 导航
├── telescope.nvim      (模糊搜索)
└── telescope-fzf-native (fzf 排序)

Git
└── gitsigns.nvim       (Git 状态)

会话
└── auto-session        (自动会话)

UI
├── tokyonight.nvim     (主题)
├── lualine.nvim        (状态栏)
└── bufferline.nvim     (标签栏)
```

---

## 常用命令

| 命令 | 说明 |
|-----|------|
| `:Lazy` | 打开插件管理器 |
| `:Lazy sync` | 同步所有插件 |
| `:Lazy update` | 更新插件 |
| `:Lazy clean` | 清理未使用的插件 |
| `:Mason` | 打开 LSP 服务器管理 |
| `:Trouble` | 打开诊断列表 |
| `:TSInstall {lang}` | 安装 Treesitter parser |
| `:TSUpdate` | 更新 Treesitter parser |
