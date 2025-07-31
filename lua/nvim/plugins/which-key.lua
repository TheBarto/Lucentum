-- This plugin is used to make easy to remember the user's defined key maps.
-- When you are going to type a command in normal mode, when press the leader key it will
-- say to you which keys are associated to the different commands.
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- This init makes the function run during neovim startup instead at the plugins load
    init = function()
        -- Load the information after 500 milliseconds
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
    },
}
