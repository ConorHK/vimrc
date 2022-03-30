local utils = require("utils")
local autocmds = {
	spellcheck = {
		{ "FileType", "text,markdown", "setlocal spell" },
	},
	restore_cursor = {
		{ "BufWinLeave", "*.*", "mkview" },
		{ "BufWinEnter", "*.*", "silent! loadview" },
	},
}
utils.augroups(autocmds)
