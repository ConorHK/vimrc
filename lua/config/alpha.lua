local M = {}

function M.setup()
	local present, alpha = pcall(require, "alpha")
	if not present then
		return
	end

	local dashboard = require("alpha.themes.dashboard")
	local function header()
		return {
			[[                                   ▒▒▒▒▒░░▒▒                                ]],
			[[                    ▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒                              ]],
			[[                ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▒▒░▒░░░░░░▒▒                            ]],
			[[            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░▒▒▒▒▒░▒▒                          ]],
			[[           ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░▒▒▒░▒                        ]],
			[[        ░░▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░▒░░▒▒▒▒                      ]],
			[[       ░▒▒▒░▒▒▒▒▒▒░▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒░                 ]],
			[[       ▒▒▒▒░▒▒  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░▒░░░░░░▒▒▒▒░             ]],
			[[      ▒▒▒▒▒░▒▒ █▒▒ ▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░▒▒▒▒▒░░░░    ░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░    ]],
			[[      ▒▒▒▒▒▒░░░▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░]],
			[[      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░▒]],
			[[      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░▒]],
			[[      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▒▒              ▒▒▒▒░░░░▒▒    ]],
			[[      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒ ███████        ▒▒▒▒▒▒           ]],
			[[      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒███████████        ▒▒▒▒▒            ]],
			[[      ▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░▒▒░░▒▒▒   ██████████████    ▒▒▒▒▒▒▒             ]],
			[[      ▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒░▒▒  ████████████████   ▒▒▒▒▒▒▒▒             ]],
			[[      ▒▒░░░░░░░░░░░░░░░░░░░░▒▒▒░▒▒▒ ███████████████   ▒▒░░▒▒▒▒▒             ]],
			[[      ░░░░░░░░░░░░░░░░░░░░░░▒▒▒░░░▒▒░░░░▒▒██████████  ▒░░░░▒▒▒              ]],
			[[      ░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░████   ▒▒▒░░░░░░▒▒          ]],
			[[       ░░░░░░░░░░░▒░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒░░░░░░░░▒░░░░▒▒▒▒     ]],
			[[       ░░░░░░░░░░░▒▒░░▒░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒░░▒▒▒▒░░▒▒░░▒▒    ]],
			[[       ░░░▒▒▒▒▒▒▒▒▒▒░░▒▒░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒░░▒░░░░░▒▒▒▒▒▒▒ ]],
			[[       ░░░▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒░░▒▒▒▒▒▒░ ]],
			[[       ░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒        ▒▒▒░░░░▒▒▒  ]],
			[[       ░░░░░░░▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒                        ]],
			[[       ░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░                              ]],
			[[      ░░▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒░░░░░░                              ]],
			[[      ░▒░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░▒                               ]],
		}
	end
	dashboard.section.header.val = header()

	dashboard.section.buttons.val = {
		dashboard.button("<Ldr> t", "   Find File ", ":Telescope find_files<CR>"),
		dashboard.button("<Ldr> g", "   Grep Word", ":Telescope grep_string<CR>"),
		dashboard.button("s", "♆   Harpoon", [[:Telescope harpoon marks theme=ivy<CR>]]),
		dashboard.button("n", "   New file", ":ene <BAR> startinsert <CR>"),
		dashboard.button("up", "   Update Plugins", ":PackerSync <CR>"),
	}

	local function footer()
		-- Number of plugins
		local total_plugins = #vim.tbl_keys(packer_plugins)
		local datetime = os.date("%d-%m-%Y %H:%M:%S")
		local plugins_text = "   "
			.. total_plugins
			.. " plugins"
			.. "   v"
			.. vim.version().major
			.. "."
			.. vim.version().minor
			.. "."
			.. vim.version().patch
			.. "   "
			.. datetime

		-- Quote
		local fortune = require("alpha.fortune")
		local quote = table.concat(fortune(), "\n")

		return plugins_text .. "\n" .. quote
	end

	dashboard.section.footer.val = footer()

	dashboard.section.footer.opts.hl = "Constant"
	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Function"
	dashboard.section.buttons.opts.hl_shortcut = "Type"
	dashboard.opts.opts.noautocmd = true

	alpha.setup(dashboard.opts)
end

return M
