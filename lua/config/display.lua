local M = {}

function M.setup()
	local present, smear = pcall(require, "smear_cursor")
	if not present then
		return
	end
	smear.setup({
		legacy_computing_symbols_support = true,
	})
end

return M
