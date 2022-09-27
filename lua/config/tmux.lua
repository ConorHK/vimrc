local M = {}

function M.setup()
	local present, tmux = pcall(require, "tmux")
	if not present then
		return
	end
	tmux.setup({
		copy_sync = {
			enable = false,
		},
	})
end

return M
