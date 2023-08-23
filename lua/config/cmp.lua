local M = {}

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.setup()
	local present1, cmp = pcall(require, "cmp")
	if not present1 then
		return
	end
	local present2, lspkind = pcall(require, "lspkind")
	if not present2 then
		return
	end
	local present3, luasnip = pcall(require, "luasnip")
	if not present3 then
		return
	end

	lspkind.init()

	cmp.setup({
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = true }),

			["<Tab>"] = cmp.mapping(function(fallback)
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		},

		sources = {
			{ name = "luasnip" },
			{ name = "nvim_lua" },
			{ name = "nvim_lsp" },
			{ name = "zsh" },
			{ name = "path" },
			{ name = "buffer", keyword_length = 5 },
		},

		sorting = {
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				function(entry1, entry2)
					local _, entry1_under = entry1.completion_item.label:find("^_+")
					local _, entry2_under = entry2.completion_item.label:find("^_+")
					entry1_under = entry1_under or 0
					entry2_under = entry2_under or 0
					if entry1_under > entry2_under then
						return false
					elseif entry1_under < entry2_under then
						return true
					end
				end,

				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},

		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		formatting = {
			format = lspkind.cmp_format({
				with_text = true,
				menu = {
					buffer = "[buf]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[api]",
					path = "[path]",
					luasnip = "[snip]",
				},
			}),
		},

		experimental = {
			native_menu = false,
			ghost_text = true,
		},
	})

	cmp.setup.cmdline("/", {
		completion = {
			autocomplete = false,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp_document_symbol" },
		}, {}),
	})

	cmp.setup.cmdline(":", {
		completion = {
			autocomplete = false,
		},

		sources = cmp.config.sources({
			{
				name = "path",
			},
		}, {
			{
				name = "cmdline",
				max_item_count = 20,
				keyword_length = 4,
			},
		}),
	})
end

return M
