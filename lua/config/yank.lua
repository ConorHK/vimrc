local M = {}
function M.setup()
	local present, smartyank = pcall(require, "smartyank")
	if not present then
		return
	end
	smartyank.setup({})
end
return M
