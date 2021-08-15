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
