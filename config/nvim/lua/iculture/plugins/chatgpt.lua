return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		"nvim-telescope/telescope.nvim"
	},
	config = function()
		local chatgipiti = require('chatgpt')
		chatgipiti.setup({
			api_key_cmd = 'pass show openaikey',
			openai_params = {
				model = 'gpt-4-turbo',
				max_tokens = 3000
			},
			openai_edit_params = {
				model = 'gpt-4-turbo',
				max_tokens = 3000
			},
		})

		-- Set keymaps for easy use
		vim.keymap.set('n', '<leader>cg', '<cmd>ChatGPT<CR>', { desc = 'Open ChatGPT Overlay' })
	end
}

