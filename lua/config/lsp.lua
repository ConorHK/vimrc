local M = {}

-- Helper function to execute Ruff commands using modern Client:exec_cmd
local function ruff_command(cmd_name)
    return function()
        local ruff_clients = vim.lsp.get_clients({ name = "ruff" })
        if #ruff_clients == 0 then
            vim.notify("Ruff client not attached", vim.log.levels.WARN)
            return
        end

        ruff_clients[1]:exec_cmd("ruff.apply" .. cmd_name, {
            arguments = { { uri = vim.uri_from_bufnr(0) } },
            bufnr = vim.api.nvim_get_current_buf(),
        })
    end
end

function M.setup()
    if not vim.lsp.config then
        print("Warning: vim.lsp.config not available. Please update to Neovim 0.11+")
        return
    end

    local function contains(table, value)
        for _, table_value in ipairs(table) do
            if table_value == value then
                return true
            end
        end
        return false
    end

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

    -- Ruff configuration path
    local ruff_file = vim.fn.stdpath("config") .. "/lspconfigs/default_ruff.toml"

    local capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Global LSP configuration (applies to all servers unless overridden)
    vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
    })

    vim.filetype.add({ filename = { Config = "brazil-config" } })

    -- Server-specific configurations
    local servers = {
        bashls = {},

        barium = {
            cmd = { "barium" },
            root_markers = { "Config" },
            filetypes = { "brazil-config" },
        },

        jdtls = {
            root_markers = { ".bemol" },
            on_attach = bemol,
        },

        lua_ls = {
            server_capabilities = {
                semanticTokensProvider = vim.NIL,
            },
        },

        pyright = {
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
                python = {
                    analysis = {
                        ignore = { "*" },
                        typeCheckingMode = "off",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                    disableLanguageServices = false,
                },
            },
        },

        ruff = {
            init_options = {
                settings = {
                    configuration = ruff_file,
                },
            },
            commands = {
                RuffAutofix = {
                    ruff_command("Autofix"),
                    description = "Ruff: Fix all auto-fixable problems",
                },
                RuffOrganizeImports = {
                    ruff_command("OrganizeImports"),
                    description = "Ruff: Format imports",
                },
            },
            root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        },

        nixd = {},

        ts_ls = {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
            },
        },
    }

    -- Configure and enable each server
    for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
    end

    local disable_semantic_tokens = {
        lua = true,
    }

    -- Diagnostic configuration
    vim.diagnostic.config({
        virtual_text = false,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "E",
                [vim.diagnostic.severity.WARN] = "W",
                [vim.diagnostic.severity.INFO] = "I",
                [vim.diagnostic.severity.HINT] = "H",
            },
        },
    })

    -- Configure LSP float windows globally
    local diagnostic_float_id = nil

    local function show_diagnostics_float()
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local diagnostics = vim.diagnostic.get(0, { lnum = line })

        if #diagnostics > 0 then
            diagnostic_float_id = vim.diagnostic.open_float({ focusable = false })
        end
    end

    local function close_diagnostic_float()
        if diagnostic_float_id then
            pcall(vim.api.nvim_win_close, diagnostic_float_id, true)
            diagnostic_float_id = nil
        end
    end

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        callback = show_diagnostics_float,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        callback = close_diagnostic_float,
    })

    -- LspAttach autocmd for keymaps and custom behavior
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local bufnr = args.buf
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

            local settings = servers[client.name] or {}

            bemol()

            -- local builtin = require("telescope.builtin")
            require("inc_rename").setup({})

            -- Set up keymaps with buffer-local scope
            local opts = { buffer = bufnr }
            -- vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true, buffer = bufnr })

            vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)

            -- Disable semantic tokens for specific filetypes
            local filetype = vim.bo[bufnr].filetype
            if disable_semantic_tokens[filetype] then
                client.server_capabilities.semanticTokensProvider = nil
            end

            -- Override server capabilities
            if settings.server_capabilities then
                for k, v in pairs(settings.server_capabilities) do
                    if v == vim.NIL then
                        v = nil
                    end
                    client.server_capabilities[k] = v
                end
            end
        end,
    })

    -- Disable Ruff hover in favor of Pyright
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "ruff" then
                client.server_capabilities.hoverProvider = false
            end
        end,
        desc = "LSP: Disable hover capability from Ruff",
    })
end

return M
