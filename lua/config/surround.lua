local M = {}
function M.setup()
	local present, _ = pcall(require, "nvim-surround")
	if not present then
		return
	end
end
return M
