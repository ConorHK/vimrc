local M = {}
function M.setup()
	local present, blink = pcall(require, "blink.cmp")
	if not present then
		return
	end
	blink.setup({
		fuzzy = {
			prebuiltBinaries = {
				download = false
			}
		}
	})
end
return M
