-- This plugins will help to recover a neovim session easily when we close
-- neovim and stop working and in the future we want to recover those sessions.

return {
    "rmagatti/auto-session",
    config = function()
        local auto_session = require("auto-session")

        auto_session.setup({
            -- Configure to not restore any session by itself, and supress some directories from the autorestore
            auto_restore_enabled = false,
            auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads/", "~/Documents/", "~/Desktop/" },
        })

        local keymap = vim.keymap

        -- cw = Current Working Directory
        -- wr -> Working session Restore
        -- ws -> Working session Save
        -- This command for LOAD A SESSION
        keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Resore session for cwd" })
        -- This command for SAVE A CURRENT SESSION
        keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>",    { desc = "Save session for auto session root directory"})
    end,
}
