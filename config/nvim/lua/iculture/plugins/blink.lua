return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',

    opts = {
        enabled = function()
            return not vim.list_contains({ 'DressingInput' }, vim.bo.filetype)
                and vim.bo.buftype ~= 'prompt'
                and vim.b.completion ~= false
        end,
        keymap = {
            preset = 'super-tab',
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },
        appearance = {
            nerd_font_variant = 'mono'
        },
        completion = {
            list = {
                selection = { preselect = true, auto_insert = true }
            },
            documentation = {
                window = {
                    border = "rounded",
                    winblend = 15,
                },
            },
            menu = {
                draw = { treesitter = { "lsp" } },
                border = "rounded",
                winblend = 15,
            },
        },
        signature = {
            enabled = false,
            trigger = {
                enabled = true,
                show_on_keyword = false,
                show_on_trigger_character = true,
                show_on_insert = false,
                show_on_insert_on_trigger_character = true,
            },
            window = {
                border = "rounded",
                winblend = 15,
            },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
