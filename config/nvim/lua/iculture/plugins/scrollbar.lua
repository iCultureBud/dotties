return {
	'petertriho/nvim-scrollbar',
	event = { 'BufReadPre', 'BufNewFile' },
	dependencies = 'f4z3r/gruvbox-material.nvim',
	config = function()
		local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')

		require('scrollbar').setup({
			hide_if_all_visible = true,
			excluded_filetypes = {
				'prompt',
				'TelescopePrompt',
				'DressingSelect',
				'NvimTree'
			},
			handle = {
				blend = 0,
			},
			marks = {
				Cursor = {
					text = "•",
					color = colors.blue,
				},
				Search = {
					text = { '' },
					color = colors.yellow,
				},
				Error = {
					text = { '' },
					color = colors.red,
				},
				Warn = {
					text = { '' },
					color = colors.orange,
				},
				Info = {
					text = { '' },
					color = colors.blue,
				},
				Hint = {
					text = { '' },
					color = colors.green,
				},
				Misc = {
					text = { "-", "=" },
					color = colors.purple,
				},
				GitAdd = {
					text = '',
					color = colors.green,
				},
				GitChange = {
					text = '',
					color = colors.yellow,
				},
				GitDelete = {
					text = '',
					color = colors.red,
				},
			}
		})

		-- Enable GitSigns
		require("scrollbar.handlers.gitsigns").setup()
	end
}
