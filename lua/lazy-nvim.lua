-- https://github.com/folke/lazy.nvim

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	-- -- UI setting --
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- 启用的功能
			dashboard = {
				enabled = true,
				preset = {
					pick = function()
						return Snacks.picker.files()
					end,
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = function() Snacks.picker.grep() end },
						{ icon = " ", key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
						{ icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			terminal = { enabled = true },
			-- 会话管理不再由 snacks 提供：2.31.0 起 session 模块已被删除
			-- （仓库里没有 lua/snacks/session.lua），原来这里的
			-- autosave/should_save 整块是无人消费的死配置，而 dashboard 的 s 键
			-- 调用 Snacks.session.restore() 会直接抛 E5108。
			-- 现在改由下面的 folke/persistence.nvim 负责，dashboard 用
			-- section = "session" 让 snacks 自己接上 require('persistence').load()。
			words = { enabled = true },
			bigfile = { enabled = true },
			scroll = {
				enabled = true,
				animate = {
					duration = { step = 15, total = 250 },
					easing = "outQuad",
				},
			},
			explorer = {
				enabled = true,
				-- 兼容 nvim-tree 的快捷键
				keys = {
					{ "<CR>", action = "edit" },
					{ "<C-v>", action = "vsplit" },
					{ "<C-x>", action = "split" },
					{ "a", action = "create" },
					{ "d", action = "delete" },
					{ "r", action = "rename" },
					{ "c", action = "copy" },
					{ "x", action = "cut" },
					{ "p", action = "paste" },
					{ "y", action = "copy_name" },
					{ "Y", action = "copy_path" },
					{ "gy", action = "copy_absolute_path" },
					{ ".", action = "toggle_hidden" },
					{ "<C-]>", action = "cd" },
					{ "<BS>", action = "cd_up" },
				},
			},

			-- 明确禁用不需要的功能
			input = { enabled = false },
			lazygit = { enabled = false },
			quickfile = { enabled = false },
			scope = { enabled = false },
			statuscolumn = { enabled = false },
			toggle = { enabled = true },
		},
		keys = {
			{
				"<leader>;",
				function() Snacks.dashboard() end,
				desc = "Dashboard",
			},
			{
				"<leader>e",
				function() Snacks.explorer() end,
				desc = "File Explorer",
			},
		},
	},

	{
		-- 会话持久化。snacks.nvim 从 2.31.0 起删掉了自带的 session 模块，
		-- dashboard 里那行 section = "session" 会去探测外部会话插件并自动接上
		-- 对应的恢复命令，persistence.nvim 在探测列表的第一位
		-- （snacks/dashboard.lua:831）。
		--
		-- 这里用 lazy = false，而不是 README 建议的 event = "BufReadPre"：
		-- dashboard 是 scratch buffer，不触发 BufReadPre，而恢复动作是一句裸的
		-- require('persistence')；插件还没被 lazy 装进 rtp 时会直接找不到模块。
		"folke/persistence.nvim",
		lazy = false,
		config = function()
			local persistence = require("persistence")
			persistence.setup({
				dir = vim.fn.stdpath("state") .. "/sessions/",
				need = 0,
				branch = true, -- git 仓库里按分支分开保存
			})
			-- setup 里的 start() 只认 need 这一条，把它的 VimLeavePre 撤掉，
			-- 自动保存规则全部由下面自己接管（stop 只删 augroup "persistence"，
			-- 不影响稍后手动调 save()）
			persistence.stop()

			-- persistence 3.x 的 defaults 只剩 dir/need/branch，原来 snacks.session
			-- 的两条规则（只在 git 仓库自动存、少数目录不存）已经没有对应选项，
			-- 这里改成退出前按 cwd 判断一次。
			-- 挂在 VimLeavePre 而不是启动时的 VimEnter：VimEnter 在 headless 下不触发、
			-- 测不到，而退出时再判断还能保住原来 should_save 那种动态语义。
			-- finddir(".git", cwd .. ";") 会从 cwd 向上查找，实测在仓库子目录里
			-- 也能命中；不带 ";" 时返回空，所以这个写法不能省。
			-- 目录名两边都要归一化：':p' 只在目标确实是已存在的目录时才补尾部的
			-- "/"，所以拿 getcwd() .. "/" 去查这张表刚好能对上——目录不存在时它
			-- 不可能成为 cwd，等它被建出来，下次启动的 setup 也会重新展开出带
			-- 斜杠的 key。
			local skip = {}
			for _, d in ipairs({ "$HOME", "$HOME/Projects", "$HOME/Downloads", "/" }) do
				skip[vim.fn.fnamemodify(vim.fn.expand(d), ":p")] = true
			end
			vim.api.nvim_create_autocmd("VimLeavePre", {
				group = vim.api.nvim_create_augroup("session.autosave", { clear = true }),
				callback = function()
					local cwd = vim.fn.getcwd() .. "/"
					if skip[cwd] or vim.fn.finddir(".git", cwd .. ";") == "" then
						return
					end
					local files = 0
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
							files = files + 1
						end
					end
					if files > 0 then
						persistence.save()
					end
				end,
			})
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd("colorscheme tokyonight-night")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},

	{
		"kylechui/nvim-surround",
		version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
				--     Old text                    Command         New text
				-- --------------------------------------------------------------------------------
				--     surr*ound_words             ysiw)           (surround_words)
				--     surr*ound_words             ysiw(           ( surround_words )
				--     *make strings               ys$"            "make strings"
				--     [delete ar*ound me!]        ds]             delete around me!
				--     remove <b>HTML t*ags</b>    dst             remove HTML tags
				--     'change quot*es'            cs'"            "change quotes"
				--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
				--     delete(functi*on calls)     dsf             function calls
			})
		end,
	},

	-- uilts setting --

	{
		-- 语法高亮的 parser + queries 来源。
		--
		-- 提交 57866b8 以"用 Neovim 0.12 内置 treesitter"为由删掉了 nvim-treesitter，
		-- 但内置的范围只有 c / lua / markdown(markdown_inline) / query / vim / vimdoc
		-- 这几个语言（$VIMRUNTIME/lib/nvim/parser 下只有这几个 .so，queries 同名几个）。
		-- python 不在其中：parser 只是当年 nvim-treesitter 编译后留在
		-- $DATA/site/parser/python.so 的遗物，queries 随插件一起被删了，
		-- 所以 vim.treesitter.query.get("python", "highlights") 是 nil，
		-- 高亮只能退回 regex syntax（&syntax=python）。
		--
		-- 该仓库现在的主分支是针对 0.12 重写的版本，只装 parser + queries，
		-- 高亮/折叠/缩进的开关都交给 Neovim 原生 API，需要自己接（见 README
		-- "Supported features": These are not automatically enabled）。
		-- 旧的 master 分支已锁定，只保证 Nvim 0.11。
		"nvim-treesitter/nvim-treesitter",
		-- 官方明确不支持懒加载：queries 必须在 FileType 触发前就进 rtp
		lazy = false,
		-- 编译 parser 依赖 tree-sitter-cli（README 要求 0.26+，本机 0.27.1）和 C 编译器；
		-- TSUpdate 只更新已经装过的 parser，首次安装靠下面 config 里的 install()
		build = ":TSUpdate",
		config = function()
			-- 幂等：已安装则直接返回，不会重复编译
			require("nvim-treesitter").install({ "python" })

			local group = vim.api.nvim_create_augroup("TreeSitterHighlight", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "python",
				desc = "为 python 启用 Neovim 内置的 treesitter 高亮",
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
					-- 这个判断不能省：highlights 查询不存在时 vim.treesitter.start()
					-- 不报错，但会把 &syntax 清空 —— 结果是 regex 高亮被关掉、
					-- treesitter 又没有捕获规则，整个文件一点颜色都没有（实测）。
					-- 缺查询时宁可留在 regex syntax 上。
					if not lang or not vim.treesitter.query.get(lang, "highlights") then
						return
					end
					-- parser 还没编译完时 get_parser 会报错，pcall 兜住继续用 regex
					pcall(vim.treesitter.start, ev.buf, lang)
				end,
			})
		end,
	},

	"lewis6991/gitsigns.nvim",

	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},

	{
		-- 该仓库已从 echasnovski 个人账号迁到 nvim-mini 组织，
		-- 旧地址靠 301 重定向还能用，但 issue/PR 都在 monorepo 里进行。
		-- tag 列表不变（最新 v0.18.0），version = "*" 解析结果与迁移前一致。
		"nvim-mini/mini.pairs",
		version = "*",
		lazy = false,
		opts = {},
	},
	{
		"saghen/blink.indent",
		-- 原先写的是 "1.*"，把版本锁在了首发 v1.0.0，而仓库已到 v2.3.0。
		-- 官方 README 的安装片段不带 version，这里保留 pin 仅为避免自动跳大版本。
		version = "2.*",
		--- @module 'blink.indent'
		--- @type blink.indent.Config
		opts = {
			blocked = {
				-- default: 'terminal', 'quickfix', 'nofile', 'prompt'
				buftypes = { include_defaults = true },
				-- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
				filetypes = { include_defaults = true },
			},
			mappings = {
				-- which lines around the scope are included for 'ai': 'top', 'bottom', 'both', or 'none'
				border = "both",
				-- set to '' to disable
				-- textobjects (e.g. `y2ii` to yank current and outer scope)
				object_scope = "ii",
				object_scope_with_border = "ai",
				-- motions
				goto_top = "[i",
				goto_bottom = "]i",
			},
			static = {
				enabled = true,
				char = "▎",
				whitespace_char = nil, -- inherits from `vim.opt.listchars:get().space` when `nil` (see `:h listchars`)
				priority = 1,
				-- specify multiple highlights here for rainbow-style indent guides
				-- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
				highlights = { "BlinkIndent" },
			},
			scope = {
				enabled = true,
				char = "▎",
				priority = 1000,
				-- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
				-- highlights = { 'BlinkIndentScope' },
				-- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
				highlights = { "BlinkIndentOrange", "BlinkIndentViolet", "BlinkIndentBlue" },
				-- enable to show underlines on the line above the current scope
				underline = {
					enabled = false,
					-- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
					highlights = {
						"BlinkIndentOrangeUnderline",
						"BlinkIndentVioletUnderline",
						"BlinkIndentBlueUnderline",
					},
				},
			},
		},
	},
	-- LSP --
	"mason-org/mason.nvim",
	"mason-org/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({
				-- Lightbulb - 代码操作提示
				lightbulb = {
					enable = true,
					sign = true,
					virtual_text = false,
				},
				-- Symbol in Winbar - 面包屑导航
				symbol_in_winbar = {
					enable = true,
				},
				-- Beacon - 跳转高亮
				beacon = {
					enable = true,
				},
			})
		end,
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},

	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = true } },
			signature = { enabled = true },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = function(bufnr)
						if require("conform").get_formatter_info("ruff_format", bufnr).available then
							return { "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					bash = { "shfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					yaml = { "yamlfmt" },
					json = { "jq" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
}, {
	-- 以下是 lazy.nvim 自身的设置，必须作为 setup() 的第二个参数（opts）传入。
	-- 之前它们写在第一个参数的 spec 列表里，会被当成插件条目静默忽略：
	-- 实测 options.checker.enabled 仍为 false、rocks.enabled 仍为 true。
	rocks = {
		enabled = false,
	},
	-- 安装插件时使用的兜底 colorscheme
	install = { colorscheme = { "habamax" } },
	-- 自动检查插件更新
	checker = { enabled = true },
})
