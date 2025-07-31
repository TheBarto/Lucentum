-- Get an interactive search and navigation interface for
-- files symbols and other content's exploration and search 
return {
    "nvim-telescope/telescope.nvim",
    -- Specifies a specific brancih
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", build="make"},
        "nvim-tree/nvim-web-devicons",
    },

    --This function will run when telescope runs
    config = function()
        local telescope = require("telescope")
        local actions   = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- Load the fzf extension to have better performance
    telescope.load_extension("fzf")

    --set custom keymaps
    local keymap = vim.keymap --load the current keymap set
    
    -- "n" is for normal mode
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fg", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>",         { desc = "Find todos" })
    

    -- This are for searching definitions, references, symbols inside the proyect.
    keymap.set("n", "<leader>fD", "<cmd>Telescope lsp_definitions<cr>",      { desc = "Find the definition of the function under the cursor" })
    keymap.set("n", "<leader>fR", "<cmd>Telescope lsp_references<cr>",       { desc = "Find all the references of the element under the cursor" })
    keymap.set("n", "<leader>fS", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols in cwd" })
    keymap.set("n", "<leader>fI", "<cmd>Telescope lsp_implementations<cr>",  { desc = "Show elements(functions) implementations"})
    keymap.set("n", "<leader>fT", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Find the TYPE DEFINITION of a structure/array/..."})
   
    end,
}
