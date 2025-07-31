-- This plugin helps you to focus at the current code,
-- because it temporarily darkens the unused code
return {
  "folke/twilight.nvim",
  lazy = false,
  cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
  keys = {
    { "<leader>tw", "<cmd>Twilight<CR>", desc = "Toggle Twilight" },
  },
  opts = {
    dimming = {
      alpha = 0.3,
      color = { "Normal", "#3a3a3a" },
      term_bg = "#3a3a3a",
    },
    context = 10,
    -- things we want to darken when they are not used
    expand = {
      "if_statement",
      "function",
      "method",
      "for_statement",
      "while_statement",
      "switch_statement",
      "try_statement",
      "compound_statement",
      "condition",
    },
    exclude = {},
  },
  config = function()
    -- Activarlo automáticamente al abrir buffers
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        vim.cmd("TwilightEnable")
      end,
    })
  end,
  config = function()
    -- Activarlo automáticamente al abrir buffers
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        vim.cmd("TwilightEnable")
      end,
    })
  end,
}
