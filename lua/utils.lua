local utils = {}

local scopes = { o = vim.o, b = vim.bo, w = vim.wo }
local api = vim.api

function utils.map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- function to set autogroups easily
-- https://github.com/Th3Whit3Wolf/dots/blob/main/private_dot_config/private_nvim/private_lua/private_autocmd.lua
function utils.augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command("augroup " .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

-- remapping functions Th3Whit3Wolf https://tinyurl.com/j5bnwzdm
function utils.map(lhs, rhs, opts)
	local options = { noremap = false }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("", lhs, rhs, options)
end

function utils.nmap(lhs, rhs, opts)
	local options = { noremap = false }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("n", lhs, rhs, options)
end

function utils.vmap(lhs, rhs, opts)
	local options = { noremap = false }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("v", lhs, rhs, options)
end

function utils.smap(lhs, rhs, opts)
	local options = { noremap = false }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("s", lhs, rhs, options)
end

function utils.xmap(lhs, rhs, opts)
	local options = { noremap = false }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("x", lhs, rhs, options)
end

function utils.imap(lhs, rhs, opts)
	local options = { noremap = false }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("i", lhs, rhs, options)
end

function utils.lmap(lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("i", lhs, rhs, options)
end

function utils.cmap(lhs, rhs, opts)
	local options = { noremap = false, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("c", lhs, rhs, options)
end

function utils.tmap(lhs, rhs, opts)
	local options = { noremap = false, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("t", lhs, rhs, options)
end

function utils.map(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("", lhs, rhs, options)
end

function utils.nnoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("n", lhs, rhs, options)
end

function utils.vnoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("v", lhs, rhs, options)
end

function utils.snoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("s", lhs, rhs, options)
end

function utils.xnoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("x", lhs, rhs, options)
end

function utils.inoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("i", lhs, rhs, options)
end

function utils.lnoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("i", lhs, rhs, options)
end

function utils.cnoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("c", lhs, rhs, options)
end

function utils.tnoremap(lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	api.nvim_set_keymap("t", lhs, rhs, options)
end

return utils
