if nixCats("java") then
	local function contains(table, value)
	    for _, table_value in ipairs(table) do
		if table_value == value then
		    return true
		end
	    end

	    return false
	end

	-- gathers all of the bemol-generated files and adds them to the LSP workspace
	local function bemol()
	    local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
	    local ws_folders_lsp = {}
	    if bemol_dir then
		local file = io.open(bemol_dir .. "/ws_root_folders", "r")
		if file then
		    for line in file:lines() do
			table.insert(ws_folders_lsp, line)
		    end
		    file:close()
		end

		for _, line in ipairs(ws_folders_lsp) do
		    if not contains(vim.lsp.buf.list_workspace_folders(), line) then
			vim.lsp.buf.add_workspace_folder(line)
		    end
		end
	    end
	end
	local jdtls = require "jdtls"
	local jdtls_setup = require "jdtls.setup"

	local root_markers = { ".bemol", }
	local root_dir = jdtls_setup.find_root(root_markers)
	local config = {
	    cmd = { "jdtls" },
	    root_dir = root_dir,
	    -- run our bemol function when the LSP attaches to the buffer
	    on_attach = bemol,
	}

	jdtls.start_or_attach(config)
end

vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
