local M = {}
function M.setup()
	local map = vim.keymap.set

	local default_opts = { noremap = true, silent = true }

	local function cnoreabbrev(command)
		vim.api.nvim_command("cnoreabbrev " .. command)
	end

	local present, _ = pcall(require, "zellij-nav")
	if not present then
		-- split sane bindings
		map("n", "<c-Left>", "<c-w>h", default_opts)
		map("n", "<c-Down>", "<c-w>j", default_opts)
		map("n", "<c-Up>", "<c-w>k", default_opts)
		map("n", "<c-Right>", "<c-w>l", default_opts)

		map("n", "<c-h>", "<c-w>h", default_opts)
		map("n", "<c-j>", "<c-w>j", default_opts)
		map("n", "<c-k>", "<c-w>k", default_opts)
		map("n", "<c-l>", "<c-w>l", default_opts)
	end

	-- quick yanking to the end of the line
	map("n", "Y", "y$", default_opts)

	-- clear highlight
	map("n", "<esc><esc>", ":noh<return>", default_opts)

	-- misspellings
	cnoreabbrev("Qa qa")
	cnoreabbrev("Q q")
	cnoreabbrev("Qall qall")
	cnoreabbrev("Q! q!")
	cnoreabbrev("Qall! qall!")
	cnoreabbrev("qQ q@")
	cnoreabbrev("Bd bd")
	cnoreabbrev("bD bd")
	cnoreabbrev("qw wq")
	cnoreabbrev("Wq wq")
	cnoreabbrev("WQ wq")
	cnoreabbrev("Wq wq")
	cnoreabbrev("Wa wa")
	cnoreabbrev("wQ wq")
	cnoreabbrev("W w")
	cnoreabbrev("W! w!")
end
return M
