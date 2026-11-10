# Neovim 配置文档

> 最后更新: 2026-11-10（修复 mason `ensure_installed` 方向，接通 Treesitter 折叠回退；其余章节仍待复核）
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
| `\` | 本地 Leader 键（在 lazy-nvim.lua 中设置） |

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
| `foldexpr` | 自定义函数 | 有支持 foldingRange 的 LSP 时用 `vim.lsp.foldexpr()`，否则回退 `vim.treesitter.foldexpr()` |
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
| `image` | 内联图片显示 |
| `notifier` | 通知提示 |
| `picker` | 模糊选择器 |
| `toggle` | 功能切换 |

**禁用的功能**: input, lazygit, quickfile, scope, statuscolumn

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
- **配置**: 使用 tokyonight 主题，简洁配置

**显示内容**:
- 左侧: 模式 | 分支 | 差异 | 诊断 | 文件名
- 右侧: 编码 | 文件格式 | 文件类型 | LSP 服务器 | 进度 | 位置

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

#### snacks.picker（替代 telescope.nvim）
- **来源**: `folke/snacks.nvim` 内置模块
- **功能**: 模糊搜索（文件、文本、buffer、帮助等）
- **优势**: 与 snacks 生态集成，Rust 后端，性能优于 telescope

**已移除的插件**:
- `nvim-telescope/telescope.nvim`
- `nvim-lua/plenary.nvim`
- `nvim-telescope/telescope-fzf-native.nvim`

---

#### nvim-treesitter
- **仓库**: `nvim-treesitter/nvim-treesitter`，`main` 分支（面向 Neovim 0.12 的重写版）
- **职责**: 只提供 parser + queries。高亮、折叠、缩进这些能力是 Neovim 原生的，**开关要自己接**
- **配置位置**: `lua/lazy-nvim.lua` 里的 spec（`lazy = false` + `build = ":TSUpdate"`）

**为什么又装回来**：提交 57866b8 以"仓库已归档、改用 Neovim 0.12 内置 treesitter"为由删掉了它，
两个前提现在都不成立。

1. 内置只覆盖 7 种语言。`$VIMRUNTIME/lib/nvim/parser` 下只有 c / lua / markdown /
   markdown_inline / query / vim / vimdoc 这几个 `.so`，`$VIMRUNTIME/queries/` 也只有同名这几个。
   python 不在其中。自动开启同样是逐语言写死的：`$VIMRUNTIME/ftplugin/lua.lua`、`c.lua`、
   `markdown.lua`、`query.lua` 里各有一句 `vim.treesitter.start()`，而 python 只有老的 `python.vim`。
2. 该仓库已恢复维护：默认分支改成 `main`，最后提交 2026-11-07；被锁死的是旧 `master`
   分支（只保证 Nvim 0.11）。

所以删掉插件之后 python 的实际状态是：parser 还在（当年编译的产物留在
`$DATA/site/parser/python.so`），queries 没了（`$DATA/site/queries/*` 是指向插件目录的软链，
插件一删全成断链），于是 `vim.treesitter.query.get("python", "highlights")` 返回 nil，
高亮退回 regex syntax。

**当前接法**（重写版 README 的 "Supported features" 明确写着 *These are not automatically enabled*）:

```lua
-- 幂等：已装则直接返回。parser 版本按 parsers.lua 里 pin 的 revision 对齐
require("nvim-treesitter").install({ "python" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
		if not lang or not vim.treesitter.query.get(lang, "highlights") then
			return
		end
		pcall(vim.treesitter.start, ev.buf, lang)
	end,
})
```

> [!WARNING]
> 中间那句 `query.get(...) == nil` 的判断不能省。实测在"有 parser、无 highlights 查询"的
> buffer 上调 `vim.treesitter.start()`：不报错、返回 true，但会把 `&syntax` 清空——
> regex 高亮被关掉，treesitter 又没有捕获规则，整个文件一个颜色都没有。
> 缺查询时必须留在 regex syntax 上。

**依赖**: `tree-sitter-cli` ≥ 0.26（本机 0.27.1，`brew install tree-sitter`）+ C 编译器 + `tar` + `curl`。
`:checkhealth nvim-treesitter` 全绿。

**已安装的语言**（`:checkhealth nvim-treesitter` 实测；图例 H/L/F/I/J = highlights/locals/folds/indents/injections）:

| 语言 | H L F I J | 高亮是否真的开启 |
| --- | --- | --- |
| python | ✓ ✓ ✓ ✓ ✓ | ✅ 由上面的 `FileType` 自动开启 |
| lua, c, markdown | ✓ ✓ ✓ ✓ ✓（markdown 缺 L/I） | ✅ Neovim 自带 `ftplugin/*.lua` 开启 |
| cpp, json, yaml, rust, regex, markdown_inline | 见 checkhealth | ❌ queries 回来了，但没人调 `start()`，仍走 regex |

**命令**: `:TSInstall {lang}`、`:TSUpdate`。
（此前文档写的"`:TS install`，旧命令 `:TSInstall` 已废弃"是错的：重写版在
`plugin/nvim-treesitter.lua` 里注册的用户命令仍然是 `TSInstall` / `TSUpdate`。）

**折叠**: `lua/core/options.lua` 的 `foldexpr` 指向自定义 `nvim_foldexpr()`：
当前 buffer 有支持 `textDocument/foldingRange` 的 LSP 时走 `vim.lsp.foldexpr()`，
否则回退到 `vim.treesitter.foldexpr()`。`LspAttach` / `LspDetach` 维护 buffer 变量
`fold_lsp_ready`。实测 pyright **没有** `foldingRangeProvider`，所以 python 实际用的是
treesitter 折叠；`foldlevel=99` 默认全部展开，`za` / `zR` / `zM` 正常。

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

**`ensure_installed` 用的是 nvim-lspconfig 的 server 名，不是 mason-registry 包名。**
`mason-lspconfig` 会先用 `mappings.lspconfig_to_package` 把 server 名翻译成 mason 包名再去安装；
写成包名时启动会报 `Server "..." is not a valid entry in ensure_installed`，对应的 LSP 也不会被安装/启用。

| 写入 `ensure_installed`（server 名） | mason 实际安装的包名 | 语言 |
| --- | --- | --- |
| `lua_ls` | `lua-language-server` | Lua |
| `bashls` | `bash-language-server` | Bash |
| `clangd` | `clangd` | C/C++ |
| `pyright` | `pyright` | Python |
| `yamlls` | `yaml-language-server` | YAML |
| `jsonls` | `json-lsp` | JSON |

`clangd` 和 `pyright` 恰好两名一致，容易让人误以为其余的也可以直接写包名。
映射由 `mason-lspconfig.mappings` 提供，可用下面一行在 Neovim 命令行自查（已验证输出为上表）：

```vim
:lua local m = require("mason-lspconfig.mappings").get_mason_map() vim.iter(require("mason-lspconfig.settings").current.ensure_installed):each(function(s) print(s, "→", m.lspconfig_to_package[s]) end)
```

---

#### lua_ls 参数补全 (`lua/lsp/lua_ls.lua`)

`mason-lspconfig` 的 `automatic_enable` 直接用 nvim-lspconfig 自带的 `lsp/lua_ls.lua`，
那份配置只设了 `codeLens`/`hint`，**没有**告诉语言服务器"这是 Neovim 的 LuaJIT 环境、
`vim` 全局的类型定义在 `$VIMRUNTIME` 里"——这两条只写在该文件头部的 `---@brief`
文档注释里，要用户自己抄，不会自动生效。

缺它们时 lua-language-server 解析不出 `vim` 的类型，只能退回工作区词表，
返回的候选 `kind` 全是 `Text(1)`；而 blink.cmp 对 lua_ls 有个内置 hack
（`blink/cmp/sources/lsp/hacks/lua_ls.lua`，upstream 提交 `2f2ebc5`）会把
`kind == Text` 的候选整个丢掉，两边叠加后 `vim.` 后面一个补全都不出。

本模块用 `vim.lsp.config("lua_ls", {...})` 在 `lsp.mason` 之前把参数合并进去：

| 设置 | 值 | 作用 |
|-----|------|------|
| `Lua.runtime.version` | `LuaJIT` | 按 LuaJIT 语义解析 `vim`、`bit` 等 |
| `Lua.runtime.path` | `lua/?.lua`, `lua/?/init.lua` | 按 `:h lua-module-load` 解析 `require()` |
| `Lua.workspace.library` | `$VIMRUNTIME` + nvim-lspconfig 类型目录 | 让 `_meta/*.lua` 里的 `vim.*` 定义可见 |
| `Lua.diagnostics.globals` | `{ "vim" }` | 不再报 `undefined global: vim` |

`on_init` 里保留了 lspconfig 文档给出的判断：项目自带 `.luarc.json`/`.luarc.jsonc`
时直接 return，不覆盖项目自己的配置（`stdpath("config")` 本身除外）。
用 `tbl_deep_extend("force", ...)` 合并，所以 `codeLens`/`hint` 仍然保留。

**已知边界**：即使配置正确，`vim.` / `vim.api.` 后面**不带前缀**时 lua_ls 仍只回 1 条
（`vim`/`api`，kind=Field），敲出前缀才有完整列表——这是 lua_ls 对"由赋值推断出的
全局表"的处理方式，与 blink.cmp 无关。实测（nvim 0.12.6 + lua_ls 3.19.2 + blink 1.10.2）：

| 位置 | 服务器返回 | blink 显示 |
|-----|-----------|-----------|
| `local x = vim.` | 1（Field） | lsp=1 |
| `local x = vim.api.nvim_` | 101（Function 等） | lsp=101 |
| `local x = vim.o.` | 9 | lsp=9 |
| `local x = require('blink.cmp').` | 82（Field/Function/Snippet） | lsp=82 |

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

LSP 能力由 `plugin/blink-cmp.lua` 自动注入 `vim.lsp.config('*')`（nvim >= 0.11），
不需要在 `lua/` 里手写。补全项的 `kind` 会被 blink 按服务器名做二次过滤，
lua_ls 的 `kind == Text` 全部丢弃，详见上面 `lua_ls 参数补全` 一节。

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

#### lspsaga.nvim
- **仓库**: `nvimdev/lspsaga.nvim`
- **功能**: LSP UI 增强

**功能模块**:
- Finder - 符号查找（definition/references/implementation）
- Rename - 重命名
- Hover - 文档悬浮窗
- Diagnostic - 诊断显示和跳转
- Code Action - 代码操作
- Outline - 符号大纲
- Call Hierarchy - 调用层次
- Lightbulb - 代码操作提示
- Beacon - 跳转高亮
- Symbol in Winbar - 面包屑导航
- Float Terminal - 浮动终端

**快捷键**:

| 按键 | 功能 |
|-----|------|
| `gh` | Finder（符号查找） |
| `gp` | 预览定义 |
| `gd` | 跳转定义 |
| `gt` | 跳转类型定义 |
| `gr` | 重命名 |
| `K` | 悬停文档 |
| `<leader>ca` | 代码操作 |
| `<leader>o` | 大纲 |
| `<leader>ci` | 入向调用 |
| `<leader>co` | 出向调用 |
| `[e` / `]e` | 诊断跳转 |
| `[E` / `]E` | 错误跳转 |
| `<leader>sl` | 显示行诊断 |
| `<leader>sb` | 显示 buffer 诊断 |
| `<leader>sw` | 显示工作区诊断 |
| `<leader>sc` | 显示光标诊断 |
| `<C-\>` | 浮动终端 |

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

#### persistence.nvim
- **仓库**: `folke/persistence.nvim`
- **功能**: 会话持久化（基于原生 `:mksession`）
- **加载**: `lazy = false`，保证 dashboard 的恢复动作能直接 `require('persistence')`

**配置**:
- 会话目录: `stdpath("state")/sessions/`
- `need = 0` + `branch = true`（git 仓库按分支分开保存）
- 插件自带的 `VimLeavePre` 自动保存已 `stop()` 关掉，改由配置里自己的一条 `VimLeavePre` 决定何时 `save()`

**自动保存规则**（沿用原 snacks.session 的两条）:
- 只在 git 仓库里保存（`finddir(".git", cwd .. ";")`，会从 cwd 向上查找）
- 忽略目录: `~/`、`~/Projects`、`~/Downloads`、`/`
- 至少有一个文件 buffer 才保存

**恢复**: 不自动恢复。dashboard 里按 `s`（该项用 `section = "session"`，
snacks 探测到 persistence 后自动接上 `:lua require('persistence').load()`），
或手动执行同一条命令。

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

### 4.2 Snacks Picker 快捷键

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
│   ├── lsp/
│   │   ├── lua_ls.lua          # lua_ls 参数（LuaJIT + $VIMRUNTIME 库）
│   │   ├── lspsaga.lua         # Lspsaga 快捷键
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
├── lspsaga.nvim        (LSP UI 增强)
└── conform.nvim        (代码格式化)

编辑增强
├── nvim-treesitter     (语法高亮)
├── nvim-surround       (surrounds 操作)
├── mini.pairs          (自动配对)
├── blink.indent        (缩进引导)
└── hardtime.nvim       (防止低效按键)

搜索 & 导航
└── snacks.picker       (模糊搜索，内置于 snacks.nvim)

Git
└── gitsigns.nvim       (Git 状态)

会话
└── persistence.nvim    (会话持久化)

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
| `:TSInstall {lang}` | 安装 Treesitter parser |
| `:TSUpdate` | 更新 Treesitter parser |
