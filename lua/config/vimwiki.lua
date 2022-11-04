local M = {}
local map = vim.keymap.set

function M.setup()
	vim.g.vimwiki_list = {
		{
			path = "~/docs/wiki",
			syntax = "markdown",
			ext = ".md",
		},
	}
	vim.g.vimwiki_key_mappings = {
		all_maps = 0,
	}

	map("n", "<Leader>ww", ":VimwikiIndex<CR>")
	map("n", "<Leader>wt", ":VimwikiTabIndex<CR>")
	map("n", "<Leader>ws", ":VimwikiTabUISelect<CR>")
	map("n", "<Leader>wi", ":VimwikiDiaryIndex<CR>")
	map("n", "<Leader>w<Leader>w", ":VimwikiMakeDiaryNote<CR>")
	map("n", "<Leader>w<Leader>t", ":VimwikiTabMakeDiaryNote<CR>")
	map("n", "<Leader>w<Leader>y", ":VimwikiMakeYesterdayDiaryNote<CR>")
	map("n", "<Leader>w<Leader>m", ":VimwikiMakeTomorrowDiaryNote<CR>")
end

return M
