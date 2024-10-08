local M = {}
function M.setup()
	local present, _ = pcall(require, "Comment")
	if not present then
		return
	end
end
return M
