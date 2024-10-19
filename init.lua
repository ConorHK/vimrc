require("nixCatsUtils").setup {
	non_nix_value = true,
}
if not require("nixCatsUtils").isNixCats then
require("config")
