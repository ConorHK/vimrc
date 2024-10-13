local M = {}
function M.setup()
	local present, blink = pcall(require, "blink.cmp")
	if not present then
		return
	end
	blink.setup(
		{
			keymap = {
				accept = "<Enter>",
				select_prev = { "<Up>", "<S-Tab>" },
				select_next = { "<Down>", "<Tab>" },
			},
			signature_help = {
				enabled = true,
			},
			highlight = {
				use_nvim_cmp_as_default = true,
			},
		}
	)
end
return M
