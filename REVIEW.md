# Neovim 配置 Review 报告

> 最后更新: 2026-11-10（修复第 16 条 mason 回归，新增第 17 条 treesitter 折叠回退）

## 已修复的问题

### 1. NvimTree 残留引用 ✅ 已修复
**问题**: `lua/core/keymaps.lua` 中有 `:NvimTreeToggle<cr>` 的快捷键映射
**修复**: 已移除，现在使用 snacks.explorer

### 2. 折叠配置重复 ✅ 已修复
**问题**: `lua/lsp/keymaps.lua` 和 `lua/core/options.lua` 都有折叠相关的 LspAttach 配置
**修复**: 移除了 keymaps.lua 中的重复配置，保留 options.lua 的全局配置

### 3. Lualine 配置简化 ✅ 已修复
**问题**: 221 行自定义 "eviline" 配置，硬编码颜色值
**修复**: 使用 lualine 内置 tokyonight 主题，简化为 27 行

### 4. Bufferline 图标编码 ✅ 已修复
**问题**: 图标使用旧版 Powerline 私有码位，可能显示为空
**修复**: 改为标准 Nerd Font 码位 U+F467/U+F421

### 5. 添加 which-key ✅ 已完成
**功能**: 快捷键提示插件，提升易用性
**快捷键**: `<leader>?` 显示当前 buffer 的快捷键

### 6. 会话管理迁移 ✅ 已完成（已被 13 取代）
**原方案**: `auto-session`
**新方案**: ~~`snacks.nvim` 的 session 功能~~ → `folke/persistence.nvim`（见第 13 条）
**好处**: 统一生态，减少插件数量

### 7. Dashboard session 配置错误 ✅ 已修复（已被 13 取代）
**问题**: `section = "session"` 缺少 action，按 `s` 键无效果
**修复**: 添加 `action = function() Snacks.session.restore() end`
**后续**: snacks 2.31.0 删掉了 session 模块，这个 action 反而变成报错源，见第 13 条

### 8. Session should_save 逻辑错误 ✅ 已修复
**问题**: `vim.fn.isdirectory(".git")` 只检查当前目录
**修复**: 使用 `vim.fn.finddir(".git", ...)` 向上查找 git 仓库
**后续**: `should_save` 随 snacks session 模块一起消失，同样的规则搬到了第 13 条的 `VimLeavePre` 判断里

### 9. 删除 trouble.nvim ✅ 已完成
**原因**: 与 lspsaga outline 功能重复
**结果**: 减少冗余，统一使用 lspsaga 的符号和诊断功能

### 10. Lspsaga 配置精简 ✅ 已完成
**改进**: 从 130 行精简到约 25 行，只保留非默认配置
**保留**: lightbulb、symbol_in_winbar、beacon 等关键功能

### 11. 删除空的 lsp.lua ✅ 已完成
**问题**: 文件只有 3 行注释，无实际功能
**修复**: 删除文件并从 init.lua 移除引用

### 12. blink 插件版本策略统一 ✅ 已完成
**问题**: blink.indent 使用 `*`，blink.cmp 使用 `1.*`
**修复**: 统一为 `1.*`，使用主版本 1 的语义化版本

### 13. Snacks.session 已不存在 ✅ 已修复
**问题**: snacks.nvim 2.31.0 起删除了自带的 session 模块（仓库里没有
`lua/snacks/session.lua`），配置里 dashboard `s` 键的
`Snacks.session.restore()` 直接抛 E5108，`opts.session` 整块（autosave 的
四条目录规则 + should_save）成了无人消费的死配置
**修复**: 换成 `folke/persistence.nvim`
- `lazy = false`：dashboard 是 scratch buffer，不触发 `BufReadPre`，而恢复动作
  是一句裸的 `require('persistence')`，插件没进 rtp 时会找不到模块
- dashboard 那行改回 `section = "session"`，由 snacks 探测外部会话插件自动接上
  `:lua require('persistence').load()`
- 原来的两条规则（只在 git 仓库自动存、`~/`、`~/Projects`、`~/Downloads`、`/`
  不存）persistence 3.x 已无对应选项，改成自己挂一条 `VimLeavePre`：
  不合格目录直接 return，合格时再数一遍文件 buffer，有才 `save()`
- 判断挂在 `VimLeavePre` 而不是启动时的 `VimEnter`：`VimEnter` 在无头测试里不
  触发、测不到，退出时判断也保住了原来 `should_save` 的动态语义

**验证**: 无 git 目录、`$HOME`、无文件 buffer 三种情况都不落盘；git 仓库及其子
目录都会存；`require('persistence').load()` 能把 buffer 恢复回来；启动 messages 为空

### 14. "blink.cmp 未接入 LSP" ✅ 已修复（结论修正）
**排查结论**: 这条是上一轮 review 误报。blink 与 LSP 的接线本来就在：
`plugin/blink-cmp.lua` 会向 `vim.lsp.config('*')` 注入补全能力，
`sources.default` 含 `lsp`，真终端实测 `local x =` 处 blink 直接给出 53 条
`source_id = lsp` 的候选。

真正让人以为"没接 LSP"的是在 `vim.` 后面补全整个消失，链路是：
- 配置里没有任何 `lua_ls` 参数。nvim-lspconfig 自带的 `lsp/lua_ls.lua` 只设
  `codeLens`/`hint`，`Lua.runtime.version = 'LuaJIT'` 和
  `Lua.workspace.library = {VIMRUNTIME}` 只写在它头部的 `---@brief` 注释里，
  要自己抄
- 于是 lua_ls 认不出 `vim` 全局的类型，退回工作区词表猜测：真终端里对
  `local x = vim.` 返回 100 条候选，`kind` **全为 Text(1)**（还混着从中文注释
  里捡来的词）
- blink 对 lua_ls 有个内置 hack（`sources/lsp/hacks/lua_ls.lua`，upstream
  `2f2ebc5`，"filter out text completion items only for lua_ls"）把 `kind == Text`
  整个丢掉 → 100 条变 0 条，菜单直接消失

**修复**: 新增 `lua/lsp/lua_ls.lua`，按 nvim-lspconfig 文档给的写法
`vim.lsp.config('lua_ls', { settings, on_init })` 注入 LuaJIT 运行时、
`$VIMRUNTIME` + lspconfig 类型库、`diagnostics.globals = {'vim'}`；项目自带
`.luarc.json` 时保持不动。`init.lua` 里放在 `require('lsp.mason')` 之前。
没有去 monkey-patch blink 的 hack——那是上游有意行为，喂对参数后就不再需要。

**验证**（nvim 0.12.6 / lua_ls 3.19.2 / blink.cmp 1.10.2）:
- `client.settings.Lua` 里 runtime/workspace 已生效，且 lspconfig 原有的
  `codeLens`/`hint` 仍在（深合并）
- 带 `.luarc.json` 的目录：`on_init` 提前 return，未注入
- 同一个 headless 探针，修复前后对比：`local x = vim.` 由"服务器 100 条全 Text /
  blink 显示 0"变为"1 条 Field / blink 显示 1"；`vim.api.nvim_` 101 条 Function
  全部显示；`require('blink.cmp').` 82 条 Field/Function/Snippet 全部显示
- 启动 messages 里没有与 blink/lua_ls 相关的报错（当时没注意到里面还混着 4 条
  mason-lspconfig 的 WARN，那部分见下面第 16 条）

**遗留**: `vim.`、`vim.api.` 后面不带前缀时 lua_ls 仍只回 1 条（对"由赋值推断出的
全局表"不做无前缀枚举），敲出前缀即恢复，与本仓库配置无关。
另注：测试期间在真 pty 下跑出过 `E1568: Terminal did not respond to DSR request`，
那是无终端模拟器应答的 pty 环境所致，真实终端里不出现。

---

### 15. Python 文件没走 treesitter 高亮 ✅ 已修复
**问题**: 打开 `.py` 只有 regex syntax 着色——`&syntax=python`、`vim.b.ts_highlight = nil`、
`highlighter.active` 为空。

**根因**: 都在提交 57866b8"移除 nvim-treesitter，改用 Neovim 0.12 内置 treesitter"这一步里，
它的前提不成立：
- 内置只覆盖 7 种语言。`$VIMRUNTIME/lib/nvim/parser/` 和 `$VIMRUNTIME/queries/` 下都只有
  c / lua / markdown / markdown_inline / query / vim / vimdoc。python 只有老的 `python.vim`。
- "自动开高亮"也不是全局行为，是逐语言写死的：`$VIMRUNTIME/ftplugin/{lua,c,markdown,query}.lua`
  里各有一句 `vim.treesitter.start()`。python 没有这一句。
- 插件删掉后，python 的 parser 反而还在——`$DATA/site/parser/python.so` 是当年的编译产物，
  能正常加载（`language.inspect` 通过、树能 parse）。丢的是 queries：
  `$DATA/site/queries/*` 全是指向 `lazy/nvim-treesitter/runtime/queries/*` 的软链，
  插件目录一没就全成断链。实测 `nvim_get_runtime_file('queries/python', true)` 返回 `{}`，
  `query.get('python', 'highlights')` 返回 nil。

**陷阱（决定修法）**: 只补一句 `vim.treesitter.start()` 会把事情弄得更糟。实测在
"有 parser、无 highlights 查询"的 buffer 上调它：不报错、返回 true、highlighter 也确实
attach 上（`active` 里有这个 buf），但它会把 `&syntax` 清空，而自己的 query 是 nil——
结果 regex 和 treesitter 两头都没着色，第 1 行 25 个字符的 synID 全是 NONE。
所以开启之前必须先确认查询存在。

**修复**: 重新引入 `nvim-treesitter/nvim-treesitter`，用 `main` 分支（面向 0.12 的重写版；
该仓库已恢复维护、最后提交 2026-11-07，被锁定的是只支持 0.11 的 `master`）。
它只装 parser + queries，高亮开关按上游 README 的要求自己接。spec 在 `lua/lazy-nvim.lua`：
`lazy = false`（上游明确不支持懒加载）+ `build = ":TSUpdate"` + `config` 里
`install({ "python" })`，以及一条先判 `query.get(lang, "highlights")` 再
`pcall(vim.treesitter.start, ...)` 的 `FileType python`。

**验证**（真 pty，`TERM=xterm-256color`、`COLORTERM=truecolor`、tokyonight-night）:

| 文件 | ft | `&syntax` | `ts_highlight` | captures |
| --- | --- | --- | --- | --- |
| python 样本（类/装饰器/async/类型注解/f-string） | python | `[]` | true | 280，37 个组 |
| mason.lua | lua | `[]` | true | 92 |
| options.lua | lua | `[]` | true | 458 |
| sample.md | markdown | `[]` | true | 11 |
| sample.json | json | `[json]` | nil | 0（未挂 autocommand，保住 regex） |
| sample.sh | sh | `[sh]` | nil | 0（同上，保护分支生效） |

- python 那 37 个 capture 组逐个解析颜色：`@keyword.function`→#bb9af7、
  `@function.call`→#7aa2f7、`@type.builtin`→#27a1b9、`@string`→#9ece6a、
  `@variable.parameter`→#e0af68 ……只有 `@spell` / `@nospell` / `@none` / `@keyword.type`
  无定义（前三个本来就不该有颜色；作为对照，lua 也同样只有 `@spell` 无定义）
- 树里 0 个 ERROR 节点，`vim.notify` 挂上探针后零条告警
- `:checkhealth nvim-treesitter` 与 `:checkhealth vim.treesitter` 全绿；python 的
  H/L/F/I/J 五个 ✓ 齐；ABI 15（要求 ≥13）、tree-sitter-cli 0.27.1（README 要求 ≥0.26）

**顺带**: queries 软链恢复后，cpp / json / yaml / rust / regex 的查询也一起回来了，
但这些 filetype 没挂 autocommand，仍走 regex，需要时照 python 那条加 pattern 即可。
`site/parser-info/python.revision` 是 `v0.25.0`，与 `parsers.lua` 里 pin 的 revision 一致，
所以 `install()` 每次启动都是 no-op、`:TSUpdate` 也不会重建那颗 7 月编译的 `.so`——
状态是自洽的，不是碰巧没崩。

**顺带发现（已修复，见第 17 条）**: `lua/core/options.lua:87` 那句注释
"折叠配置：使用 LSP 折叠（当 LSP 不可用时回退到 treesitter）"当时不成立。
`$VIMRUNTIME/lua/vim/lsp/_folding_range.lua:339` 的 `M.foldexpr()` 在没有
LSP folding state 时直接 `return '0'`，代码里没有任何 treesitter 分支。
真 pty 实测：同一份 python 样本，`foldexpr` 设为 `v:lua.vim.treesitter.foldexpr()` 时
`zM` 折叠出 2/11/31/39 四处、层级 1~2 正确；换回配置里的 `v:lua.vim.lsp.foldexpr()`
（该 buffer 已挂着 1 个 pyright 客户端）后 `zM` 折叠行数 = 0。
现在由自定义 `nvim_foldexpr()` 接通：有支持 foldingRange 的 LSP 时走 LSP，否则回退
treesitter；pyright 没有 foldingRange，所以 python 实际走 treesitter。

---

### 16. mason-lspconfig 的 `ensure_installed` 上一轮被我改错了 ✅ 已修复
**问题**: 提交 390cadf（已推送）把 `ensure_installed` 从 server 名改成了 mason 包名，
理由是"`lua_ls`/`bashls`/`yamlls`/`jsonls` 在 mason 里查不到，会被静默跳过"。
**这个结论是反的。**

**证据**（真 pty 的启动 messages，不是 headless 推断）:
```
[mason-lspconfig.nvim] Server "lua-language-server" is not a valid entry in ensure_installed.
Make sure to only provide lspconfig server names.
```
另外两句分别打在 `bash-language-server`、`yaml-language-server`、`json-lsp` 上。
报错的正好是 4 个"包名 ≠ server 名"的条目，`clangd` 和 `pyright` 因为两边同名所以不报。

**代码依据**: `lua/mason-lspconfig/features/ensure_installed.lua` 里
`resolve_package(lspconfig_server_name)` 查的是
`server_mapping.lspconfig_to_package[条目名]`——入参是 **server 名**，插件内部再换算成包名。
上一轮我拿的是 `package_to_lspconfig`，方向看反了。

**为什么本机看不出来**: 六个 server 都装在 `~/.local/share/nvim/mason/` 里了，
`ensure_installed` 只在"没装"时才动作。真正的影响是新机器上这 4 个不会被自动装，
而 `automatic_enable` 又只对已安装的生效，于是静默缺一半 LSP。

**影响面**: `lua/lsp/mason.lua` 六项里四项要改回 `lua_ls` / `bashls` / `yamlls` / `jsonls`
（`clangd`、`pyright` 不动），加上文件头那段注释，以及 CONFIG.md 的"mason 包名"整张表
——那张表的表头方向也是错的。插件版本没变（HEAD 仍是 10-23 的 `c302d3f`，
今天 18:42 曾短暂 checkout 到 `97ccf96` 又回滚），所以不是升级导致的行为变化。

**修复**: `ensure_installed` 已改回 `lua_ls` / `bashls` / `clangd` / `pyright` /
`yamlls` / `jsonls`，文件头注释和 CONFIG.md 的映射表也按 server 名方向重写。
真 PTY 启动后 `:messages` 里那 4 条 WARN 已消失。

---

### 17. treesitter 折叠只有注释、没有回退 ✅ 已修复
**问题**: `lua/core/options.lua` 的注释写着"LSP 不可用时回退到 treesitter"，
但 `foldexpr` 直接指向 `vim.lsp.foldexpr()`。没有 LSP folding 支持时它返回 `"0"`，
不会自动改用 treesitter。

**证据**（真 PTY，python 文件）: pyright 的 `server_capabilities.foldingRangeProvider`
是 `nil`，`client:supports_method("textDocument/foldingRange")` 为 `false`；
直接 `vim.lsp.foldexpr()` 拿不到任何层级。停掉 LSP 后改走 treesitter，
`foldlevel()` 对测试文件返回 `1:1 2:2 3:3 4:3 5:2 6:1 ...`，与嵌套结构一致；
`za` 也能正常关折叠。

**修复**: `foldexpr` 改为自定义 `nvim_foldexpr()`：`LspAttach`/`LspDetach` 维护
buffer 变量 `fold_lsp_ready`，有支持 foldingRange 的 client 时走 LSP，
否则 `pcall(vim.treesitter.foldexpr)`，失败再退回 `"0"`。

---

## 当前配置状态

### ✅ 没有问题的部分

| 项目 | 状态 | 说明 |
|-----|------|------|
| 插件维护状态 | ✅ | 所有插件都在积极维护中 |
| 插件冲突 | ✅ | nvim-surround 和 mini.pairs 功能互补，无冲突 |
| 快捷键冲突 | ✅ | 无重复或冲突的快捷键 |
| API 使用 | ✅ | 无废弃 API |

---

## 总结

### 配置健康度: 🟢 优秀 (95/100)

**优点**:
- ✅ 所有插件都是现代化的、积极维护的
- ✅ 功能完整，无明显缺失
- ✅ 快捷键设计合理
- ✅ 已修复所有残留引用和重复配置
- ✅ 配置简洁，易于维护
- ✅ 统一使用 snacks.nvim 生态
- ✅ 使用 lspsaga 提供完整的 LSP 体验

**已完成优化**:
- ✅ Lualine 配置简化（221 行 → 27 行）
- ✅ Bufferline 图标编码修复
- ✅ 添加 which-key 插件
- ✅ 会话管理迁移到 persistence.nvim
- ✅ 补齐 lua_ls 参数（`vim.` 处补全消失的真因，非 blink 未接 LSP）
- ✅ python 重新接上 treesitter 高亮（57866b8 删插件后 queries 断链，详见第 15 条）

**待处理**:
- ✅ `ensure_installed` 已改回 server 名，启动 WARN 消失（第 16 条）
- ✅ treesitter 折叠回退已接通（第 17 条）
- ✅ 删除 trouble.nvim（与 lspsaga 重复）
- ✅ Lspsaga 配置精简（130 行 → 25 行）
- ✅ 删除空的 lsp.lua
- ✅ blink 插件版本策略统一

### 当前插件列表

**UI**:
- snacks.nvim (dashboard, explorer, terminal, words, bigfile, scroll)
- tokyonight.nvim (主题)
- lualine.nvim (状态栏)
- bufferline.nvim (标签栏)

**LSP**:
- mason.nvim + mason-lspconfig.nvim (LSP 服务器管理)
- lspsaga.nvim (LSP UI 增强)
- blink.cmp (代码补全)
- conform.nvim (代码格式化)

**编辑增强**:
- nvim-treesitter (语法高亮)
- nvim-surround (surrounds 操作)
- mini.pairs (自动配对)
- blink.indent (缩进引导)
- hardtime.nvim (防止低效按键)

**搜索 & 导航**:
- telescope.nvim + telescope-fzf-native (模糊搜索)

**Git**:
- gitsigns.nvim (Git 状态)

**工具**:
- which-key.nvim (快捷键提示)
- persistence.nvim (会话持久化)

---

## 所有优化已完成 ✅

所有识别出的问题都已修复，配置现在处于优秀状态。
