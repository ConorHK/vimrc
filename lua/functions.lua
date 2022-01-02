local utils = require("utils")
-- relative line numbers
utils.opt("o", "number", true)
local autocmds = {
	--- Current window has hybrid numbers
	--- All other windows have absolute numbers
	number_toggle = {
		{ "BufEnter,FocusGained,InsertLeave", "*", "set relativenumber" },
		{ "BufLeave,FocusLost,InsertEnter", "*", "set norelativenumber" },
	},
	spellcheck = {
		{ "FileType", "text,markdown", "setlocal spell" },
	},
	disableAutoComment = {
		{ "FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
	},
	restore_cursor = {
		{ "BufRead", "*", [[call setpos(".", getpos("'\""))]] },
	},
}
utils.augroups(autocmds)
