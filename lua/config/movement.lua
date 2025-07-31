local M = {}

function M.setup()
	local present, ai = pcall(require, "mini.ai")
	if not present then
		return
	end
	ai.setup()
	local present, surround = pcall(require, "mini.surround")
	if not present then
		return
	end
	surround.setup()

	local present, operators = pcall(require, "mini.operators")
	if not present then
		return
	end
	operators.setup()
end

return M
