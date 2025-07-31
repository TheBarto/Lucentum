-- File explorer and tree stile file navigator, which apears at the side window,
-- which allows to navigate, open, move, rename or eliminate files and folders.
return {
    "nvim-tree/nvim-tree.lua",
    -- This dependencies option is to fulfill a dependency of the plugin (which is in another git repository)
    dependencies = "nvim-tree/nvim-web-devicons",
    -- This function always run on the plugin load.
    config = function()
        local nvimtree = require("nvim-tree")

        -- recommended settings frm nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            -- This will set the default width and relative numbers in the file explore
            view = {
                width = 35,
                relativenumber = true,
            },
            -- change folder arrow icons
            --renderer = {
            --    indent_markers = {
            --    enable = true,
            --    },
            --}
            -- disable window_picker for
            -- explorer to work well with
            -- window splits
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
            -- Also show files ignore by git
            git = {
                ignore = false,
            },
        })

        --set custom keymaps
        local keymap = vim.keymap -- load current key maps to be sure

        keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>",         { desc = "Toggle file explorer" })                          -- toggle file explorer
        keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file location" }) -- toggle file explorer on current file location
        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>",       { desc = "Collapse file explorer" })                        -- collapse file explorer
        keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>",        { desc = "Refresh file explorer" })                         -- refresh file explorer
        -- <cmd> is the equivalent of ':' in normal mode to do a command
    end
}
