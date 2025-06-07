local M = {}
function M.setup()
	require("grug-far").setup({})

	vim.keymap.set({ "n", "x" }, "<leader>r", function()
		local search = vim.fn.getreg("/")
		-- surround with \b if "word" search (such as when pressing `*`)
		if search and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
			search = "\\b" .. search:sub(3, -3) .. "\\b"
		end
		require("grug-far").open({
			prefills = {
				search = search,
			},
		})
	end, { desc = "grug-far: Search using @/ register value or visual selection" })
end
return M
