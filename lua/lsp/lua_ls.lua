-- lua_ls 的配置补全。
--
-- mason-lspconfig 的 automatic_enable 用的是 nvim-lspconfig 自带的 lua_ls 配置，
-- 那份配置里只有 codeLens/hint 两个开关；"这是 Neovim 的 LuaJIT 环境、vim 全局的
-- 类型定义在 $VIMRUNTIME 里"这两条只写在它 lsp/lua_ls.lua 的 ---@brief 文档注释里，
-- 要用户自己加，不会自动生效。
--
-- 缺这两条时，lua-language-server 解析不出 `vim` 这个全局的类型，只能退回工作区词表
-- 猜测，返回的候选 kind 全是 Text(1)。而 blink.cmp 对 lua_ls 有个内置 hack
-- （runtime: blink/cmp/sources/lsp/hacks/lua_ls.lua，upstream 提交 2f2ebc5），
-- 会把 kind == Text 的候选整个丢掉——两边一叠加，`vim.` 后面一个补全都不出，
-- 看起来就像"blink 没接 LSP"。
--
-- 真终端实测（nvim 0.12.6 + lua_ls 3.19.2 + blink.cmp 1.10.2，在本仓库目录内）：
--   修复前 `local x = vim.`   → lua_ls 返回 100 条，kind 全为 Text，blink 显示 0 条
--   修复前 `local x = vim.api.` → lua_ls 返回 2 条（vim/api），kind 全为 Text，blink 0 条
vim.lsp.config("lua_ls", {
	-- 注意用 settings = { Lua = {} } 兜底，on_init 里要往 client.config.settings.Lua
	-- 上合并，不能假设它已经存在。
	settings = {
		Lua = {},
	},
	on_init = function(client)
		-- 项目自己带了 .luarc.json 时以项目为准（本仓库除外：它就是 Neovim 配置本身）
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		local library = { vim.env.VIMRUNTIME }
		-- 有 nvim-lspconfig 在 rtp 上时，顺带把它的类型标注也喂进去
		local lspconfig_lua = vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1]
		if lspconfig_lua then
			table.insert(library, lspconfig_lua)
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
			runtime = {
				version = "LuaJIT",
				-- 按 :h lua-module-load 的方式解析 require()
				path = { "lua/?.lua", "lua/?/init.lua" },
			},
			workspace = {
				checkThirdParty = false,
				library = library,
			},
			diagnostics = {
				globals = { "vim" },
			},
		})
	end,
})
