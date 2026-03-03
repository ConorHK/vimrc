local M = {}

function M.setup()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
            local jdtls = require("jdtls")

            local root_dir = require("jdtls.setup").find_root({
                ".classpath",
                ".project",
                "pom.xml",
                "build.gradle",
                "gradlew",
                ".git",
            })
            if not root_dir then
                root_dir = vim.fn.getcwd()
            end
            local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
            local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name

            -- Bemol workspace folders — added on_attach after jdtls initializes
            local bemol_dir = vim.fs.find({ ".bemol" }, { path = root_dir, upward = true, type = "directory" })[1]

            local config = {
                cmd = { "jdtls", "-data", workspace_dir },
                root_dir = root_dir,
                capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        import = { enabled = true },
                        rename = { enabled = true },
                    },
                },
                on_attach = function(_, bufnr)
                    if bemol_dir then
                        local file = io.open(bemol_dir .. "/ws_root_folders", "r")
                        if file then
                            for line in file:lines() do
                                if not vim.tbl_contains(vim.lsp.buf.list_workspace_folders(), line) then
                                    vim.lsp.buf.add_workspace_folder(line)
                                end
                            end
                            file:close()
                        end
                    end

                    local opts = { buffer = bufnr }
                    vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
                    vim.keymap.set("n", "<leader>jev", jdtls.extract_variable, opts)
                    vim.keymap.set("v", "<leader>jem", jdtls.extract_method, opts)
                end,
            }

            jdtls.start_or_attach(config)
        end,
    })
end

return M
