-- Neovim's plugin that dims inactive windows, highlighting the active window
return {
  "sunjon/shade.nvim",
  lazy = false, -- o true si prefieres cargarlo bajo demanda
  config = function()
    require("shade").setup({
      overlay_opacity = 50,         -- Opacidad de la sombra (0-100)
      opacity_step = 1,             -- Cuánto cambia al usar los atajos para modificar opacidad
      keys = {
        brightness_up    = "<C-Up>",     -- Aumentar opacidad
        brightness_down  = "<C-Down>",   -- Disminuir opacidad
        toggle           = "<Leader>sse", -- Activar/desactivar Shade
      },
      -- Indicamos a que ficheros NO debemos aplicar el oscurecimiento de las ventanas inactivas
      exclude_filetypes = { "NvimTree", "neo-tree", "aerial", "toggleterm", "nvim-tree", "alpha" }, -- filetypes excluidos
      exclude_buftypes = { "nofile", "prompt", "popup" },
    })
  end,
}
