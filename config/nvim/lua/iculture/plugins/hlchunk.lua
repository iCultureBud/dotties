return {
	"shellRaining/hlchunk.nvim",
	dependencies = { 'iCultureBud/gruvbox-material.nvim' },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')
		require("hlchunk").setup({
			chunk = {
				enable = true,
				style = { colors.red },
			},
			indent = {
				enable = true,
				style = {
					colors.aqua,
					colors.orange,
					colors.blue,
					colors.yellow,
					colors.green,
					colors.purple,
				},
			}
		})
	end
}
