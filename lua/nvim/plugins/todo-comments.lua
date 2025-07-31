-- Highlights the key words to localize the differents
-- special elements: ERROR:, INFO:, WARNING: it's important
-- to set the ':' symbol after the keyword.
return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require("todo-comments")

    todo_comments.setup({
            keywords = {
                -- El campo alt trata de la misma manera las palabras claves que se le indiquen.
                -- En este caso sería FIXME, FIX (sinónimos) & BUG
                FIX = { color = "error", alt = {"FIXME", "BUG"}},
                TODO = {color = "info"},
                HACK = {color = "warning"},
            },
        })
    -- Cambiar los keymaps usando vim.keymap.set
    vim.keymap.set("n", "]t", function() todo_comments.jump_next() end, { desc = "Next todo comment" })
    vim.keymap.set("n", "[t", function() todo_comments.jump_prev() end, { desc = "Previous todo comment" })
    end
}
