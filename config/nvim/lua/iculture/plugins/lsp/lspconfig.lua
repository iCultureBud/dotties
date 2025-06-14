return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "folke/neodev.nvim"
    },
    config = function()
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")

        -- Create keybinds for servers automatically on lsp attach event
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                vim.api.nvim_buf_set_option(ev.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")

                local dap = require("dap")
                local widgets = require("dap.ui.widgets")
                local bufopts = { noremap = true, silent = true, buffer = ev.buf }

                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts)

                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<leader>co", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                vim.keymap.set("n", "<leader>fc", function() vim.lsp.buf.format { async = true } end, bufopts)

                vim.keymap.set("n", "<F2>", function() dap.step_out() end)
                vim.keymap.set("n", "<F3>", function() dap.step_over() end)
                vim.keymap.set("n", "<F4>", function() dap.step_into() end)
                vim.keymap.set("n", "<F5>", function() dap.continue() end)

                vim.keymap.set("n", "<F7>", function() dap.toggle_breakpoint() end)
                vim.keymap.set("n", "<F8>", function() dap.set_breakpoint() end)

                vim.keymap.set("n", "<F9>", function() dap.disconnect() end)
                vim.keymap.set("n", "<F10>", function() dap.close() end)
                vim.keymap.set("n", "<F11",
                    function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
                -- vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)
                vim.keymap.set("n", "<leader>dr", function() dap.run_last() end)
                vim.keymap.set("n", "<leader>db", function() dap.clear_breakpoints() end)
                vim.keymap.set("n", "<leader>dl", function() dap.list_breakpoints() end)

                vim.keymap.set({ "n", "v" }, "<leader>dh", function() widgets.hover() end)
                vim.keymap.set({ "n", "v" }, "<leader>dp", function() widgets.preview() end)
                vim.keymap.set("n", "<leader>df", function() widgets.centered_float(widgets.frames) end)
                vim.keymap.set("n", "<leader>ds", function() widgets.centered_float(widgets.scopes) end)
            end
        })

        -- Set diagnostic keymaps.
        local diagnostic_opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, diagnostic_opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, diagnostic_opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, diagnostic_opts)
        vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, diagnostic_opts)

        -- Configure LSP diagnostics behaviour
        vim.diagnostic.config({
            underline = true,
            virtual_text = false,
            update_in_insert = false,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                }
            }
        })

        -- Setup clang and cmake servers
        lspconfig.cmake.setup{}
        lspconfig.clangd.setup({
            init_options = {
                fallbackFlags = { "--std=c++20" }
            },
        })

        lspconfig.pylsp.setup{}
        lspconfig.harper_ls.setup{}

        -- Setup Dartls
        lspconfig.dartls.setup({
            cmd = { "dart", "language-server", "--protocol=lsp" },
            filetypes = { "dart" },
            root_dir = lspconfig.util.root_pattern("pubspec.yaml"),
            init_options = {
                onlyAnalyzeProjectsWithOpenFiles = "false",
                suggestFromUnimportedLibraries = "true",
                closingLabels = "true",
                outline = "true",
                fluttreOutline = "false"
            },
        })

        -- Setup Lua LS
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    },
                    runtime = {
                        version = "LuaJIT",
                    },
                }
            }
        })

        -- Add custom server for byteLang and setup for it
        if not configs.bytels then
            configs.bytels = {
                default_config = {
                    cmd = { "bytels", "lsp" },
                    filetypes = { "bytelang" },
                    root_dir = function(fname)
                        return lspconfig.util.find_git_ancestor(fname)
                    end,
                    settings = {},
                },
            }
        end
        lspconfig.bytels.setup{}

        local start_client = function()
            local config = {
                cmd = { "bytels", "lsp" },
                name = "bytels",
                root_dir = function(fname)
                    return lspconfig.util.find_git_ancestor(fname)
                end,
            }

            local client_id = vim.lsp.start_client(config)

            if client_id then
                vim.lsp.buf_attach_client(0, client_id)
            end
        end

        vim.api.nvim_create_user_command(
            "StartClient",
            start_client,
            { desc = "Start bytels client" }
        )

        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        vim.lsp.config("*", {
            capabilities = capabilities
        })

        -- Enable for debugging bytels
        -- vim.lsp.set_log_level("debug")
    end
}
