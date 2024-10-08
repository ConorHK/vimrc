local M = {}
function M.setup()
	local present, _ = pcall(require, "smartyank")
	if not present then
		return
	end
end
return M
