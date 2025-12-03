-- This plugin dims inactive windows, highlinhting the active windows.
-- Not completely equals to shade, but similar. It dims the colors of
-- the inactive windows, make them darker.

return {
  "levouh/tint.nvim",
  event = "VeryLazy",

  config = function()

    -- Nivel inicial de oscurecimiento
    -- (negativo -> oscurecer, positivo -> clarear)
    local tint_value = -120

    -- Aplicamos tint dinamicamente con esta funcion
    local function apply_tint()
      require("tint").setup({
        tint = tint_value,

          -- reduce colores en ventanas inactivas (efecto "difuminado")
          transforms = {
          require("tint.transforms").saturate(0.0),
        },

        -- No aplicar tint a ciertos highlights (statusline, separadores, bufferline, etc.)
        highlight_ignore_patterns = {
          "WinSeparator",
          "Status.*",
          "BufferLine.*",
          "IndentBlankline.*",
        },

        -- No tintar ventanas flotantes ni ciertos filetypes
        window_ignore_function = function(winid)
          local cfg = vim.api.nvim_win_get_config(winid)
          if cfg.relative ~= "" then
            return true -- ignorar ventanas flotantes
          end

          local bufnr = vim.api.nvim_win_get_buf(winid)
          local ft = vim.bo[bufnr].filetype

          local ignore_ft = {
            "NvimTree",
            "neo-tree",
            "TelescopePrompt",
            "lazy",
            "mason",
            "help",
          }

          return vim.tbl_contains(ignore_ft, ft)
        end,
      })

      require("tint").refresh()
    end

    -- Aplicar tint al iniciar
    apply_tint()

    ---------------------------------------------------------------------------
    --  Keymaps para cambiar intensidad en caliente (muy útil en la práctica)
    ---------------------------------------------------------------------------
    -- Oscurecer más
    vim.keymap.set("n", "<leader>tm", function()
      tint_value = tint_value - 10
      apply_tint()
      print("Tint más oscuro: " .. tint_value)
    end, { desc = "Oscurecer ventanas inactivas" })

    -- Aclarar
    vim.keymap.set("n", "<leader>tl", function()
      tint_value = tint_value + 10
      apply_tint()
      print("Tint más claro: " .. tint_value)
    end, { desc = "Aclarar ventanas inactivas" })

    -- Modo extra oscuro (toggle)
    local dark_mode = false
    vim.keymap.set("n", "<leader>td", function()
      dark_mode = not dark_mode
      tint_value = dark_mode and -120 or -60
      apply_tint()
      print("Modo oscuro fuerte: " .. tostring(dark_mode))
    end, { desc = "Toggle modo oscuro fuerte" })

    -- Toggle general del plugin
    vim.keymap.set("n", "<leader>tt", function()
      require("tint").toggle()
      print("Tint toggled")
    end, { desc = "Activar/desactivar Tint" })
  end,
}
