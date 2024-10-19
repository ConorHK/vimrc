local M = {}
function M.setup()
	local present, indent = pcall(require, "ibl")
	if not present then
		return
	end
	indent.setup()
end

return M
