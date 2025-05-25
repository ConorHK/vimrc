local M = {}

function M.setup()
	local present, flash = pcall(require, "flash")
	if not present then
		return
	end
	flash.setup({
		modes = {
			char = {
				jump_labels = true,
			},
			search = {
				enabled = false,
			},
		},
	})

	vim.keymap.set({ "n", "x", "o" }, "ss", function()
		require("flash").jump()
	end, { desc = "Flash" })
	vim.keymap.set({ "n", "x", "o" }, "SS", function()
		require("flash").treesitter()
	end, { desc = "Flash treesitter" })
	vim.keymap.set("o", "r", function()
		require("flash").remote()
	end, { desc = "Remote flash" })
	vim.keymap.set({ "x", "o" }, "R", function()
		require("flash").treesitter_search()
	end, { desc = "Flash treesitter search" })
	vim.keymap.set("c", "<c-s>", function()
		require("flash").toggle()
	end, { desc = "Toggle flash" })

	local present, ai = pcall(require, "mini.ai")
	if not present then
		return
	end
	ai.setup()
	local present, surround = pcall(require, "mini.surround")
	if not present then
		return
	end
	surround.setup()

	local present, operators = pcall(require, "mini.operators")
	if not present then
		return
	end
	operators.setup()
end

return M
