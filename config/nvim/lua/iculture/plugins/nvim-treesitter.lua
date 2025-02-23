return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPre', 'BufNewFile' },
	build = ':TSUpdate',
	dependencies = 'windwp/nvim-ts-autotag',
	config = function()
		require('nvim-treesitter.configs').setup({
			ensure_installed = {
				'bash', 'c', 'cpp',
				'dockerfile', 'go', 'json',
				'lua', 'python', 'vim', 'yaml'
			},
			autotag = { enable = true },
			autopairs = { enable = true },
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = { enable = true },
			textobjects = { enable = true },
		})
	end
}
