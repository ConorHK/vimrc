local utils = require("utils")
local nnoremap = utils.nnoremap

nnoremap("<leader>a", ":lua require('harpoon.mark').add_file()<CR>")
nnoremap("<leader>s", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
nnoremap("<leader>n", ":lua require('harpoon.ui').nav_file(1)<CR>")
nnoremap("<leader>e", ":lua require('harpoon.ui').nav_file(2)<CR>")
nnoremap("<leader>i", ":lua require('harpoon.ui').nav_file(3)<CR>")
nnoremap("<leader>o", ":lua require('harpoon.ui').nav_file(4)<CR>")

require("harpoon").setup({
    nav_first_in_list = true,
})
