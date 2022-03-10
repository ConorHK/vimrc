local cmp = require("cmp")
local lspkind = require("lspkind")
lspkind.init()

cmp.setup({
	mapping = {
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),

		["<c-space>"] = cmp.mapping({
			i = cmp.mapping.complete(),
			c = function(
				_ --[[fallback]]
			)
				if cmp.visible() then
					if not cmp.confirm({ select = true }) then
						return
					end
				else
					cmp.complete()
				end
			end,
		}),

		["<c-c>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},

	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
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
	}, {
	}),
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
