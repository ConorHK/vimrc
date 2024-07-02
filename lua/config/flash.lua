local M = {}

function M.setup()
	local present, flash = pcall(require, "flash")
	if not present then
		return
	end
	flash.setup({
		modes = {
			char = {
				jump_labels = true
			},
			search = {
				enabled = false
			}
		}
	})

end

return M
