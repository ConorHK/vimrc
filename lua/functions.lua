local utils = require("utils")
local autocmds = {
	--- Current window has hybrid numbers
	--- All other windows have absolute numbers
	number_toggle = {
		{ "BufEnter,FocusGained,InsertLeave", "*(^alpha$)@", "set relativenumber" },
		{ "BufLeave,FocusLost,InsertEnter", "*(^alpha$)@", "set norelativenumber" },
	},
	spellcheck = {
		{ "FileType", "text,markdown", "setlocal spell" },
	},
	restore_cursor = {
		{ "BufWinLeave", "*.*", "mkview"},
		{ "BufWinEnter", "*.*", "silent! loadview"},
	},
}
utils.augroups(autocmds)
