local M = {}

function M.setup()
	local whichkey = require("which-key")

	local conf = {
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
		},
	}

	local opts = {
		mode = "n", -- Normal mode
		prefix = "<leader>",
		buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `noremap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
	}

	local mappings = {
		z = {
			name = "Packer",
			c = { "<cmd>PackerCompile<cr>", "Compile" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			s = { "<cmd>PackerSync<cr>", "Sync" },
			S = { "<cmd>PackerStatus<cr>", "Status" },
			u = { "<cmd>PackerUpdate<cr>", "Update" },
		},

		h = {
			name = "Harpoon",
			a = { ":lua require('harpoon.mark').add_file()<CR>", "Add file" },
			m = { ":lua require('harpoon.ui').toggle_quick_menu()<CR>", "Toggle menu" },
			n = { ":lua require('harpoon.ui').nav_file(1)<CR>", "Go to first file" },
			e = { ":lua require('harpoon.ui').nav_file(2)<CR>", "Go to second file" },
			i = { ":lua require('harpoon.ui').nav_file(3)<CR>", "Go to third file" },
			o = { ":lua require('harpoon.ui').nav_file(4)<CR>", "Go to fourth file" },
		},

		t = {
			name = "Telescope",
			t = { ":lua require('telescope.builtin').find_files()<CR>", "Find files" },
			g = { ":lua require('telescope.builtin').live_grep()<CR>", "Grep files" },
		},
	}

	whichkey.setup(conf)
	whichkey.register(mappings, opts)
end

return M
