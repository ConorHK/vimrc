local M = {}

function M.setup()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    -- Auto open/close UI with debug sessions
    dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
    end

    -- Breakpoint signs
    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })

    -- pdb-style keymaps
    local map = vim.keymap.set
    map("n", "<leader>dc", dap.continue, { desc = "Continue (c)" })
    map("n", "<leader>dn", dap.step_over, { desc = "Step over (n)" })
    map("n", "<leader>ds", dap.step_into, { desc = "Step into (s)" })
    map("n", "<leader>dr", dap.step_out, { desc = "Step out / return (r)" })
    map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint (b)" })
    map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
    end, { desc = "Conditional breakpoint" })
    map("n", "<leader>dp", dapui.eval, { desc = "Eval expression (p)" })
    map("v", "<leader>dp", dapui.eval, { desc = "Eval selection (p)" })
    map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    map("n", "<leader>dx", dap.terminate, { desc = "Terminate session" })
end

return M
