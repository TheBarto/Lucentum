-- This plugin that allow to maximize split windows
return {
    "szw/vim-maximizer",
    -- This key mapping tells nvim to not charge the plugin
    -- until the key combination has been press
    keys = {
        { "<leader>sm", "<cmd>MaximizerToggle<CR>",
          desc = "Maximize/minimize a split" },
    },
}

