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

        local hydra = require("hydra")

        session_hint = [[
             _w_: AutoSession save
             _W_: AutoSession save with a identifier name
             _r_: AutoSession restore
             _d_: AutoSession deletePicker
             _s_: AutoSession search
             _<Esc>_: Exit
        ]]

        hydra({
            name = "Autosession",
            hint = session_hint,
            mode = "n",
            body = "<leader>w",
            config = {
                invoke_on_body = true,
            },

            heads = {
                { 'w', function() vim.api.nvim_command("AutoSession save") end, { exit_before = true, desc = "Save session" } },
                { 'W',
                    function()
                        vim.ui.input({ prompt = "name to save (without spaces): ", }, function(text)
                        if not text or text == "" then return end
                        vim.api.nvim_command("AutoSession save " .. text)
                        end)
                    end,
                    { exit = true, desc = "Save session with name"} },
                { 'r', function() vim.api.nvim_command("AutoSession restore") end, { exit_before = true, desc = "Resore session" } },
                { 'd', function() vim.api.nvim_command("AutoSession deletePicker") end, { exit_before = true, desc = "Select a session to delete it" } },
                { 's', function() vim.api.nvim_command("AutoSession search") end, { exit_before = true, desc = "Search a session to load it" } },
                { "<Esc>", nil, { exit = true } },
            },
        })
    end,

        --[[ local keymap = vim.keymap

        -- cw = Current Working Directory
        -- wr -> Working session Restore
        -- ws -> Working session Save
        -- This command for LOAD A SESSION
        keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Resore session for cwd" })
        -- This command for SAVE A CURRENT SESSION
        keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>",    { desc = "Save session for auto session root directory"})
    end, ]]
}
