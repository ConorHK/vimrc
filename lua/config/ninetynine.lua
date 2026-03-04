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

    vim.keymap.set("v", "<leader>av", function()
        _99.visual()
    end)
    vim.keymap.set("n", "<leader>ax", function()
        _99.stop_all_requests()
    end)
    vim.keymap.set("n", "<leader>as", function()
        _99.search()
    end)
    vim.keymap.set("n", "<leader>aw", function()
        _99.Extensions.Worker.set_work()
    end)
    vim.keymap.set("n", "<leader>aW", function()
        _99.Extensions.Worker.search()
    end)
end

return M
