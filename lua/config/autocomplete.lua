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
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
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
		}),
		sources = cmp.config.sources(
			{
				{ name = 'luasnip' }, -- For luasnip users.
				{ name = 'nvim_lsp' },
				{ name = "zsh"},
				{ name = "path"},
				{ name = "buffer", keyword_length=5},
				},
			{
			{ name = 'buffer' },
		})
	})

	-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
	-- Set configuration for specific filetype.
	cmp.setup.filetype('gitcommit', {
		sources = cmp.config.sources({
			{ name = 'git' },
		}, {
				{ name = 'buffer' },
			})
	})
	require("cmp_git").setup()

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ '/', '?' }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(':', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = 'path' }
		}, {
				{ name = 'cmdline' }
			}),
		matching = { disallow_symbol_nonprefix_matching = false }
	})

	-- Set up lspconfig.
	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
	require('lspconfig')['pyright'].setup {
		capabilities = capabilities
	}
	require('lspconfig')['ruff'].setup {
		capabilities = capabilities
	}
end

return M
