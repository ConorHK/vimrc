local M = {}

function M.setup()
	local present, eyeliner = pcall(require, "eyeliner")
	if not present then
		return
	end
	vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, underline = true })
	vim.api.nvim_set_hl(0, "EyelinerSecondary", { underline = true })
	eyeliner.setup({
		highlight_on_key = true,
	})
end

return M
