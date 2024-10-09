local M = {}
function M.kanagawa()
	local present, kanagawa = pcall(require, "kanagawa")
	if not present then
		return
	end
	kanagawa.setup({
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
function M.alduin()
	local present, alduin = pcall(require, "alduin")
	if not present then
		return
	end
	alduin.setup({
		colors = {
			terminal_colors = true,
			inverse = true,
		}
	})
end
function M.setup()
	M.alduin()
	vim.opt.termguicolors = true
	vim.cmd("colorscheme alduin")
end
return M
