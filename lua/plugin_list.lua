local present, _ = pcall(require, "packer_init")
local packer

if present then
    packer = require "packer"
else
    return false
end

local use = packer.use
return packer.startup(
    function()
    -- let packer manage itself
    use {'wbthomason/packer.nvim', event = "VimEnter"}
    -- lsp install
      use {
          "kabouzeid/nvim-lspinstall",
          event = "BufRead"
      }
    -- lsp config
      use {
            "neovim/nvim-lspconfig",
            after = "nvim-lspinstall",
            config = function()
                require "plugins.lspconfig"
            end
      }
    -- symbols for lsp preview
    use {'onsails/lspkind-nvim', event = "BufRead"} 
    -- treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      event = "BufRead",
      config = [[require('plugins.treesitter')]]
    }
    -- autocomplete
    --use {
      --"hrsh7th/nvim-compe",
      --event = "InsertEnter",
      --config = function()
          --require "plugins.compe"
      --end,
    --}
    -- search
    --use {
      --{
        --'nvim-telescope/telescope.nvim',
        --requires = {
          --'nvim-lua/popup.nvim',
          --'nvim-lua/plenary.nvim',
          --'telescope-frecency.nvim',
          --'telescope-fzy-native.nvim',
        --},
        --wants = {
          --'popup.nvim',
          --'plenary.nvim',
          --'telescope-frecency.nvim',
          --'telescope-fzy-native.nvim',
        --},
        --config = [[require('plugins.telescope')]],
        --cmd = 'Telescope',
        --module = 'telescope',
      --},
      --{
        --'nvim-telescope/telescope-frecency.nvim',
        --after = 'telescope.nvim',
        --requires = 'tami5/sql.nvim',
      --},
      --{
        --'nvim-telescope/telescope-fzy-native.nvim',
        --run = 'git submodule update --init --recursive',
      --},
    --}
  end
)
