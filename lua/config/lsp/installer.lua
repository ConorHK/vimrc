local M = {}

function M.setup(servers, server_options)
	local lspconfig = require("lspconfig")
	local icons = require("config.icons")

	require("mason").setup({
		ui = {
			icons = {
				package_installed = icons.server_installed,
				package_pending = icons.server_pending,
				package_uninstalled = icons.server_uninstalled,
			},
		},
	})

	require("mason-tool-installer").setup({
		ensure_installed = { "pyright", "black", "isort", "stylua", "lua-language-server" },
		auto_update = false,
		run_on_start = true,
	})

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers),
		automatic_installation = false,
	})

	-- Package installation folder
	local install_root_dir = vim.fn.stdpath("data") .. "/mason"

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
			lspconfig[server_name].setup(opts)
		end,
		["lua_ls"] = function()
			local opts = vim.tbl_deep_extend("force", server_options, servers["lua_ls"] or {})
			require("neodev").setup({})
			lspconfig.lua_ls.setup({})
			-- lspconfig.sumneko_lua.setup(require("neodev").setup { runtime_path = true, lspconfig = opts })
		end,
	})
end

return M
