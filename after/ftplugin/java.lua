local function contains(table, value)
    for _, table_value in ipairs(table) do
        if table_value == value then
            return true
        end
    end

    return false
end

-- helper function for finding a filename in a directory which matches
-- the specified pattern
local function find_file(directory, pattern)
    local filename_found = ''
    local pfile = io.popen('ls "' .. directory .. '"')

    if (pfile == nil) then
        return ''
    end

    for filename in pfile:lines() do
        if (string.find(filename, pattern) ~= nil) then
            filename_found = filename
            break
        end
    end

    return filename_found
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

local function get_parent_directory(path)
    return path:match("(.*)[/\\].*$")
end

local function get_os()
    local sysname = vim.loop.os_uname().sysname
    if sysname == "Linux" then
        return "linux"
    elseif sysname == "Darwin" then
        return "mac"
    else
        return nil -- or handle other cases as needed
    end
end

local jdtls = require "jdtls"
local jdtls_setup = require "jdtls.setup"

local home = os.getenv("HOME")
local root_markers = { ".bemol", }
local root_dir = jdtls_setup.find_root(root_markers)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name
local path_to_jdtls = get_parent_directory(vim.fn.exepath("jdtls")) .. "/../share/java/jdtls"
local path_to_config = path_to_jdtls .. "/config_" .. get_os()
-- local path_to_lombok = path_to_jdtls .. "/lombok.jar"
local path_to_plugins = path_to_jdtls .. "/plugins/"
-- the eclipse jar is suffixed with a bunch of version nonsense, so we find it by pattern matching
local path_to_jar = path_to_plugins .. find_file(path_to_plugins, "org.eclipse.equinox.launcher_")

local config = {
    cmd = { "jdtls" },
    root_dir = root_dir,
    -- run our bemol function when the LSP attaches to the buffer
    on_attach = bemol,
}

jdtls.start_or_attach(config)
