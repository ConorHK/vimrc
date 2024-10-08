local M = {}
function M.setup()
	local present, _ = pcall(require, "blink.cmp")
	if not present then
		return
	end
end
return M
