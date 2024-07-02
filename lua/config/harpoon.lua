local M = {}

function M.setup()
	local present, harpoon = pcall(require, "harpoon")
	if not present then
		return
	end

	harpoon.setup()
	local telescope_config = require("telescope.config").values
	local map = vim.keymap.set
	map(
		"n", "<leader>a",
		function()
		      harpoon:list():add()
		end
	)
	map(
		"n", "<leader>s",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end
	)
	map(
		"n", "<leader>n",
		function()
			harpoon:list():select(1)
		end
	)
	map(
		"n", "<leader>e",
		function()
			harpoon:list():select(2)
		end
	)
	map(
		"n", "<leader>i",
		function()
			harpoon:list():select(3)
		end
	)
	map(
		"n", "<leader>o",
		function()
			harpoon:list():select(4)
		end
	)

end

return M
