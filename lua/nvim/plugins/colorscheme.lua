-- This plugin will define the color scheme of nvim. 
-- The priority will indicate that it will load the first one.
-- With the config option will config the differents plugins options.
return {
    "folke/tokyonight.nvim",
    -- La maxima prioridad para que se carge antes que cualquier otro plugin visual
    priority = 1000,
    lazy = false,
    config = function()
      --[[ local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998" ]]

      -- With the options defined above, we will modify the night style of the tokyonight colorscheme
      -- and to set all the options, we need to indicate it to the plugin.
      require("tokyonight").setup({
        style = "moon",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
          functions = { bold = true },
          variables ={},
        },
        --[[ on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end, ]]

        on_highlights = function(hl, colors)
          --hl.HydraHint   = { fg = colors.magenta, link = nil }
          --hl.HydraName   = { fg = colors.magenta, bold = true }
          --hl.HydraHead   = { fg = colors.magenta, bg = colors.magenta, bold = true, link = nil, }
          --hl.HydraDesc   = { fg = colors.magenta, link = nil }
          --hl.HydraBorder = { fg = colors.magenta, link = nil }
          --hl.HydraTitle  = { fg = colors.magenta, bold = true, link = nil, }
          --[[HydraBlue, HydraPink, ... hacen referencia a los parametros color=blue, pink, etc.
          HydraBlue configura los heads asignados a la opcion color = blue. Recordar que
          la opcion color no indica los colores, sino que son "atajos" para configurar
          opciones 'exit' o 'foreign keys']]
          --hl.HydraBlue   = { fg = "#ff55de", bold = true, link = nil, }
        end,
      })

    --Load the colorscheme
    vim.cmd("colorscheme tokyonight")

    -- -- Definir grupo para ventana inactiva con fondo gris
    -- vim.cmd('highlight WinInactive guibg=#3a3a3a guifg=#3a3a3a guisp=#3a3a3a ctermfg=Grey ctermbg=Grey')
    --
    -- -- Funciones para aplicar el winhighlight según ventana activa/inactiva
    -- local function set_active_win()
    --   vim.opt_local.winhighlight = "Normal:Normal"
    -- end
    --
    -- local function set_inactive_win()
    --   vim.opt_local.winhighlight = "Normal:WinInactive"
    -- end
    --
    -- -- Crear autocomandos para cambiar el highlight según ventana
    -- vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
    --   callback = set_active_win,
    -- })
    --
    -- vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    --   callback = set_inactive_win,
    -- })
    end,
}
