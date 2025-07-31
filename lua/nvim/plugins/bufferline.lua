-- This plugins will make the tabs look nicer
return {
    "akinsho/bufferline.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            separatior_style = "slant",
        },
    },
}
