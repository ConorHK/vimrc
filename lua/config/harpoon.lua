local M = {}

function M.setup()
	local present, harpoon = pcall(require, "harpoon")
	if not present then
		return
	end

	harpoon.setup({
		nav_first_in_list = true,
	})
end

return M
