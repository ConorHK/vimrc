local M = {}
function M.setup()
	local present, kanagawa = pcall(require, "kanagawa")
	if not present then
		return
	end
	require("kanagawa").setup({
		colors = {
			theme = {
				all = {
					ui = {
						bg_gutter = "none"
					}
				}
			}
		}
	})
end
return M
