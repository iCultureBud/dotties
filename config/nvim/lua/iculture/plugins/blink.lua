return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',

    opts = {
        keymap = {
            preset = 'super-tab',
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },
        appearance = {
            nerd_font_variant = 'mono'
        },
        -- (Default) Only show the documentation popup when manually triggered
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
            enabled = true,
            window = {
                border = "rounded",
                winblend = 15,
            },
        },
        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
