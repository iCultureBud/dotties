-- Load Lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "iculture.plugins" },
		{ import = "iculture.plugins.lsp" },
	},
	install = { colorscheme = { 'gruvbox-material' } },
	ui = {
		icons = {
			loaded = "󰄳",
			not_loaded = "󰄰",
		}
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	}
})
