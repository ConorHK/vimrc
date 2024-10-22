local M = {}

function M.setup()
	local present, lspconfig = pcall(require, "lspconfig")
	if not present then
		return
	end

	require("lazydev").setup({})
	require("fidget").setup({})

	local capabilities = nil

	-- Broken at the moment and I don't work with any packages with ruff.toml defined as of today

	-- local function find_root_dir()
	-- 	local root_files = { ".git" }
	-- 	local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
	-- 	return vim.fs.dirname(paths[1])
	-- end
	-- local function file_exists(filepath)
	-- 	local stat = vim.loop.fs_stat(filepath)
	-- 	return stat and stat.type == "file"
	-- end
	--
	-- local ruff_file = find_root_dir() .. "/ruff.toml"
	-- if not file_exists(ruff_file) then
	-- 	if not require("nixCatsUtils").isNixCats then
	-- 		ruff_file = "./lspconfigs/default_ruff.toml"
	-- 	else
	-- 		ruff_file =  require("nixCats").configDir .. "/lspconfigs/default_ruff.toml"
	-- 	end
	-- end
	if not require("nixCatsUtils").isNixCats then
		ruff_file = "./lspconfigs/default_ruff.toml"
	else
		ruff_file =  require("nixCats").configDir .. "/lspconfigs/default_ruff.toml"
	end

	local capabilities = nil
	if pcall(require, "cmp_nvim_lsp") then
		capabilities = require("cmp_nvim_lsp").default_capabilities()
	end

	local servers = {
		bashls = true,
		lua_ls = {
			server_capabilities = {
				semanticTokensProvider = vim.NIL,
			},
		},
		pyright = {
			-- settings = {
			-- 	pyright = {
			-- 		disableOrganizeImports = true,
			-- 	},
			-- 	python = {
			-- 		analysis = {
			-- 			ignore = { "*" },
			-- 			typeCheckingMode = "off",
			-- 			autoSearchPaths = true,
			-- 			useLibraryCodeForTypes = true,
			-- 		},
			-- 		disableLanguageServices = false,
			-- 	},
			-- },
		},
		ruff_lsp = {
			init_options = {
				settings = {
					args = { "--config=" .. ruff_file },
				},
			},
			commands = {
				RuffAutofix = {
					function()
						vim.lsp.buf.execute_command {
							command = 'ruff.applyAutofix',
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						}
					end,
					description = 'Ruff: Fix all auto-fixable problems',
				},
				RuffOrganizeImports = {
					function()
						vim.lsp.buf.execute_command {
							command = 'ruff.applyOrganizeImports',
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						}
					end,
					description = 'Ruff: Format imports',
				},
			},
			root_dir = find_root_dir,
		},
		nixd = true,
		hls = true,
	}

	local servers_to_install = vim.tbl_filter(function(key)
		local t = servers[key]
		if type(t) == "table" then
			return not t.manual_install
		else
			return t
		end
	end, vim.tbl_keys(servers))


	if not require("nixCatsUtils").isNixCats then
		require("mason").setup()
		local ensure_installed = {
			"stylua",
			"lua_ls",
			"pyright",
			"ruff_lsp",
		}
		vim.list_extend(ensure_installed, servers_to_install)
		for i = 1, #ensure_installed do
			if ensure_installed[i] == "nixd" then
				table.remove(ensure_installed, i)
				break
			end
		end
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	end

	for name, config in pairs(servers) do
		if config == true then
			config = {}
		end
		config = vim.tbl_deep_extend("force", {}, {
			capabilities = capabilities,
		}, config)

		lspconfig[name].setup(config)
	end

	local disable_semantic_tokens = {
		lua = true,
	}

	-- LSP handlers configuration
	local config = {
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
		},

		diagnostic = {
			virtual_text = false,
			underline = false,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focusable = true,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		},
	}

	-- Diagnostic configuration
	vim.diagnostic.config(config.diagnostic)

	-- Hover configuration
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

	-- Signature help configuration
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
	vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({focusable=false})]])

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local bufnr = args.buf
			local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

			local settings = servers[client.name]
			if type(settings) ~= "table" then
				settings = {}
			end

			local present_amazon, amazon = pcall(require, "amazon")
			if present_amazon then
				amazon.bemol()
			end

			local builtin = require("telescope.builtin")

			vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
			vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
			-- vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
			vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

			vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
			vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

			local filetype = vim.bo[bufnr].filetype
			if disable_semantic_tokens[filetype] then
				client.server_capabilities.semanticTokensProvider = nil
			end

			-- Override server capabilities
			if settings.server_capabilities then
				for k, v in pairs(settings.server_capabilities) do
					if v == vim.NIL then
						---@diagnostic disable-next-line: cast-local-type
						v = nil
					end

					client.server_capabilities[k] = v
				end
			end
		end,
	})

	-- require("lint").linters_by_ft = {
	-- 	python = {"mypy"},
	-- }
	-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	-- 	callback = function()
	-- 		require("lint").try_lint()
	-- 	end,
	-- })

	-- Autoformatting Setup
	-- require("conform").setup {
	-- 	formatters_by_ft = {
	-- 		lua = { "stylua" },
	-- 	},
	-- }
	--
	-- vim.api.nvim_create_autocmd("BufWritePre", {
	-- 	callback = function(args)
	-- 		require("conform").format {
	-- 			bufnr = args.buf,
	-- 			lsp_fallback = true,
	-- 			quiet = true,
	-- 		}
	-- 	end,
	-- })
end

return M
