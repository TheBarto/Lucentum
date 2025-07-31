 -- This plugin will help us to undo actions done in the file

return {
    "mbbill/undotree",

    config = function()
        
        --set custom keymaps
        local keymap = vim.keymap --load the current keymap set

         keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>",
         { desc = "Open the undo tree" })

    end,
}
