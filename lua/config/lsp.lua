local M = {}

function M.setup()
	local present, lspconfig = pcall(require, "lspconfig")
	if not present then
		return
	end

	require("neodev").setup({})
	require("fidget").setup({})
	require("lsp_signature").setup({})

	local capabilities = nil

	local function find_root_dir()
		local root_files = { ".git" }
		local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
		return vim.fs.dirname(paths[1])
	end
	local function file_exists(filepath)
		local stat = vim.loop.fs_stat(filepath)
		return stat and stat.type == "file"
	end

	local ruff_file = find_root_dir() .. "/ruff.toml"
	if not file_exists(ruff_file) then
		ruff_file =  require("nixCats").configDir .. "/lspconfigs/default_ruff.toml"
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

	local lsp_signature_cfg = {
		debug = false, -- set to true to enable debug logging
		log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
		-- default is  ~/.cache/nvim/lsp_signature.log
		verbose = false, -- show debug line number

		bind = true, -- This is mandatory, otherwise border config won't get registered.
		-- If you want to hook lspsaga or other signature handler, pls set to false
		doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
		-- set to 0 if you DO NOT want any API comments be shown
		-- This setting only take effect in insert mode, it does not affect signature help in normal
		-- mode, 10 by default

		max_height = 12, -- max height of signature floating_window
		max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
		-- the value need >= 40
		wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
		floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

		floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
		-- will set to true when fully tested, set to false will use whichever side has more space
		-- this setting will be helpful if you do not want the PUM and floating win overlap

		floating_window_off_x = 1, -- adjust float windows x position.
		-- can be either a number or function
		floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
		-- can be either number or function, see examples

		close_timeout = 4000, -- close floating window after ms when laster parameter is entered
		fix_pos = true,  -- set to true, the floating window will not auto-close until finish all parameters
		hint_enable = false, -- virtual hint enable
		hint_prefix = "> ",  -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
		hint_scheme = "String",
		hint_inline = function() return false end,  -- should the hint be inline(nvim 0.10 only)?  default false
		-- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
		-- return 'right_align' to display hint right aligned in the current line
		hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
		handler_opts = {
			border = "rounded"   -- double, rounded, single, shadow, none, or a table of borders
		},

		always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

		auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
		extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
		zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

		padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

		transparency = nil, -- disabled by default, allow floating win transparent value 1~100
		shadow_blend = 36, -- if you using shadow as border use this set the opacity
		shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
		timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
		toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
		toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
		-- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
		-- may not popup when typing depends on floating_window setting

		select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
		move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
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

			require("lsp_signature").on_attach(lsp_signature_cfg, bufnr)
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
