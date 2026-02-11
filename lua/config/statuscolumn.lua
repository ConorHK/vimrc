local M = {}

function M.diagnostics_available()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg:supports_method(diagnostics) then
            return true
        end
    end

    return false
end

function M.hl_str(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end

function M.get_path_root(path)
    if path == "" then
        return
    end

    local root = vim.b.path_root
    if root then
        return root
    end

    local root_items = {
        ".git",
    }

    root = vim.fs.root(path, root_items)
    if root == nil then
        return nil
    end
    if root then
        vim.b.path_root = root
    end
    return root
end

local remote_cache = {}

function M.get_git_remote_name(root)
    if not root then
        return nil
    end
    if remote_cache[root] ~= nil then
        return remote_cache[root]
    end

    -- Mark as in-flight to avoid duplicate async calls
    remote_cache[root] = false

    vim.system({ "git", "-C", root, "config", "--get", "remote.origin.url" }, { text = true }, function(job)
        if job.code ~= 0 then
            return
        end
        local out = vim.trim(job.stdout)
        out = out:gsub(":", "/"):gsub("%.git$", ""):match("([^/]+/[^/]+)$")
        remote_cache[root] = out or false
        vim.schedule(function()
            vim.cmd.redrawstatus()
        end)
    end)

    return nil
end

function M.setup()
    require("statuscol").setup({
        relculright = true,
        thousands = ",",
        ft_ignore = {
            "help",
            "toggleterm",
        },
        segments = {
            {
                sign = {
                    namespace = { "diagnostic" },
                },
                condition = {
                    function()
                        return M.diagnostics_available() or " "
                    end,
                },
            },
            {
                text = {
                    "%=",
                    function(args)
                        local mode = vim.fn.mode()
                        local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

                        -- case 1
                        if normalized_mode ~= "v" and vim.v.virtnum == 0 then
                            return require("statuscol.builtin").lnumfunc(args)
                        end

                        if vim.v.virtnum < 0 then
                            return "-"
                        end

                        local line = require("statuscol.builtin").lnumfunc(args)

                        if vim.v.virtnum > 0 then
                            local num_wraps = vim.api.nvim_win_text_height(args.win, {
                                start_row = args.lnum - 1,
                                end_row = args.lnum - 1,
                            })["all"] - 1

                            if vim.v.virtnum == num_wraps then
                                line = "└"
                            else
                                line = "├"
                            end
                        end

                        -- Highlight cases
                        if normalized_mode == "v" then
                            local pos_list =
                                vim.fn.getregionpos(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode, eol = true })
                            local s_row, e_row = pos_list[1][1][2], pos_list[#pos_list][2][2]

                            if vim.v.lnum >= s_row and vim.v.lnum <= e_row then
                                return M.hl_str("CursorLineNr", line)
                            end
                        end

                        return vim.fn.line(".") == vim.v.lnum and M.hl_str("CursorLineNr", line)
                            or M.hl_str("LineNr", line)
                    end,
                    " ",
                },
                condition = {
                    function()
                        return vim.wo.number or vim.wo.relativenumber
                    end,
                },
            },
            {
                sign = {
                    namespace = { "gitsigns" },
                    maxwidth = 1,
                    colwidth = 1,
                },
                condition = {
                    function()
                        local root = M.get_path_root(vim.api.nvim_buf_get_name(0))
                        return M.get_git_remote_name(root) or " "
                    end,
                },
            },
        },
    })
end

return M
