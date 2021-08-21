local utils = require('utils')

-- relative line numbers
utils.opt('o', 'number', true)
local autocmds = {
    --- Current window has hybrid numbers
    --- All other windows have absolute numbers
    numberToggle = {
        {"BufEnter,FocusGained,InsertLeave", "*", "set relativenumber"},
        {"BufLeave,FocusLost,InsertEnter", "*", "set norelativenumber"}
    },
    spellcheck = {
      {"FileType", "text,markdown", "setlocal spell"}
    },
    disableAutoComment = {
      {"FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"}
    },
}
utils.augroups(autocmds)

-- remember last position in file
vim.cmd[[autocmd BufReadPost * lua goto_last_pos()]]
function goto_last_pos()
  local last_pos = vim.fn.line("'\"")
  if last_pos > 0 and last_pos <= vim.fn.line("$") then
    vim.api.nvim_win_set_cursor(0, {last_pos, 0})
  end
end

function toggle_quickfix()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd('cclose')
      return
    end
  end
  vim.cmd('copen')
end

function print_diagnostics(opts, bufnr, line_nr, client_id)
  opts = opts or {}

  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  --print only shows a single line, echo blocks requiring enter, pick your poison
  print(diagnostic_message)
end

vim.cmd [[ autocmd CursorHold * lua print_diagnostics() ]]
