local M = {}

function M.harpoon()
	local present, harpoon = pcall(require, "harpoon")
	if not present then
		return
	end

	harpoon.setup()
	local map = vim.keymap.set
	map("n", "<leader>a", function()
		harpoon:list():add()
	end)
	map("n", "<leader>s", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end)
	map("n", "<leader>n", function()
		harpoon:list():select(1)
	end)
	map("n", "<leader>e", function()
		harpoon:list():select(2)
	end)
	map("n", "<leader>i", function()
		harpoon:list():select(3)
	end)
	map("n", "<leader>o", function()
		harpoon:list():select(4)
	end)
end

function M.oil()
	local present, oil = pcall(require, "oil")
	if not present then
		return
	end
	oil.setup({
		columns = { "icon" },
		keymaps = {
			["<C-h>"] = false,
			["<C-l>"] = false,
			["<Leader>p"] = "actions.preview",
		},
		view_options = {
			show_hidden = true,
		},
		win_options = {
			signcolumn = "yes:1",
		},
	})

	-- Open parent directory in current window
	vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

	-- Open parent directory in floating window
	vim.keymap.set("n", "<space>-", require("oil").toggle_float)
end

function M.setup()
	M.oil()
	M.harpoon()
end

return M
