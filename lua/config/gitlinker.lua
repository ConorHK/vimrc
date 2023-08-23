local M = {}

function M.setup()
	local present, gitlinker = pcall(require, "gitlinker")
	if not present then
		return
	end

	actions = require("gitlinker.actions")

	gitlinker.setup({
		opts = {
			add_current_line_on_normal_mode = false,
			print_url = false,
		},
		callbacks = {
	        -- Custom implementation of Vim-code-browse plugin in lua
			['git.amazon.com'] = function(url_data)
				local host = url_data.host:gsub('git', 'code')
				local package = url_data.repo:gsub('pkg', 'packages')
				local package_url = 'https://' .. host .. '/' .. package
				local commit = url_data.rev
				local file_path = url_data.file
				local file_url = package_url .. '/blobs/' .. commit .. '/--/' .. file_path
				if url_data.lstart then
					file_url = file_url .. '#L' .. url_data.lstart
					if url_data.lend then
						file_url = file_url .. '-L' .. url_data.lend
					end
				end
				return file_url
			end,
		},
		mappings = nil,
	})

	vim.keymap.set(
		"n", "yc",
		function()
			gitlinker.get_buf_range_url("n", { action_callback = actions.copy_to_clipboard })
		end, { noremap = true, silent = true}
	)
	vim.keymap.set(
		"v", "yc",
		function()
			gitlinker.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
		end, { noremap = true, silent = true}
	)
end

return M
