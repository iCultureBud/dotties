return {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = function ()
        require("neorg").setup({
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
            }
        })
    end
}
