local M = {}

function M.setup()
    local ok, _99 = pcall(require, "99")
    if not ok then
        return
    end

    _99.setup({
        provider = _99.Providers.KiroProvider,
        completion = {
            source = "blink",
        },
    })

    vim.keymap.set("v", "9v", function()
        _99.visual()
    end)
    vim.keymap.set("n", "9x", function()
        _99.stop_all_requests()
    end)
    vim.keymap.set("n", "9s", function()
        _99.search()
    end)
end

return M
