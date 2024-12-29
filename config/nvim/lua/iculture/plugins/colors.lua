return {
	'iCultureBud/gruvbox-material.nvim',
	priority = 1000,
	config = function()
		require('gruvbox-material').setup({
			contrast = 'medium',
			background = {
				transparent = true,
			}
		})


		-- Set theme global
		-- vim.api.nvim_command('colorscheme gruvbox-material')

		vim.api.nvim_set_hl(0, 'GitSignsAdd', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'GitSignsDelete', { bg = 'none' })

		-- Set colors for indentation
		local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')
		vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', { fg = colors.aqua })
		vim.api.nvim_set_hl(0, 'IndentBlanklineIndent2', { fg = colors.yellow })
		vim.api.nvim_set_hl(0, 'IndentBlanklineIndent3', { fg = colors.blue })
		vim.api.nvim_set_hl(0, 'IndentBlanklineIndent4', { fg = colors.red })
		vim.api.nvim_set_hl(0, 'IndentBlanklineIndent5', { fg = colors.green })
		vim.api.nvim_set_hl(0, 'IndentBlanklineIndent6', { fg = colors.purple })

		-- Set color for Codeium in [nvim-cmp]
		vim.api.nvim_set_hl(0, 'CmpItemKindCodeium', { fg = colors.yellow })
	end
}
