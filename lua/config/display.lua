local M = {}

function M.setup()
	local smear = require("smear_cursor")
	smear.setup({
		legacy_computing_symbols_support = true,
	})
end

return M
