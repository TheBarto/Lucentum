--[[
Improves the nvim's status line.
UTILIZAR gucharmap PARA VER LOS CARACTERES QUE TIENES INSTALADOS "ESPECIALES"
COMO MESLOLGM NERD FONT. (INSTALARLO)
]]
return {
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        local colors = {
            violet = "#FF61EF",
            pink_bg = "#F072B6",
            pink_fg = "#C099FF",
            fg = "#3A3735", --"#C3CCDC",
            bg = "#5C5B5B",
        }

        local my_lualine_theme = {
            normal = {
                a = { bg = colors.bg, fg = colors.pink_fg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.pink_fg },
                c = { bg = colors.bg, fg = colors.pink_fg },
            },
            insert = {
                a = { bg = colors.bg, fg = colors.pink_fg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.pink_fg },
                c = { bg = colors.bg, fg = colors.pink_fg },
            },
            visual = {
                a = { bg = colors.bg, fg = colors.pink_fg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.pink_fg },
                c = { bg = colors.bg, fg = colors.pink_fg },
            },
            command = {
                a = { bg = colors.bg, fg = colors.pink_fg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.pink_fg },
                c = { bg = colors.bg, fg = colors.pink_fg },
            },
            replace = {
                a = { bg = colors.bg, fg = colors.pink_fg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.pink_fg },
                c = { bg = colors.bg, fg = colors.pink_fg },
            },
            inactive = {
                a = { bg = colors.bg, fg = colors.semilightgray, gui = "bold" },
                b = { bg = colors.bg, fg = colors.semilightgray },
                c = { bg = colors.bg, fg = colors.semilightgray },
            },
        }

        -- configure lualine with modified theme
        lualine.setup({
            options = {
                theme = my_lualine_theme,
                globalstatus = true, -- Para que solamente muestre 1 barra de estado de lualine
                separator = { left = "", right = "" },
                --color = { bg = colors.pink_bg ,fg = colors.pink_fg }
            },
            sections = {
                lualine_a = {
                    { "mode", gui = "bold", separator = { left = "", right = "" }, color = { bg = colors.pink_bg, fg = colors.fg } },
                    {   lazy_status.updates,
                        cond = lazy_status.has_updates,
                        --[[color = { fg = "#ff9e64" },]]
                        separator = { left = "", right = "" },
                    },
                },
                lualine_b = {
                    { "filename", path = 2, separator = { left = "", right = "" } },
                    { "filetype"},
                    { "encoding"},
                    { "fileformat"},
                },
                lualine_c = {
                    { "branch", icon = " " },
                    { "diff", symbols = { added = "", modified = "", removed = ""} },
                },
                lualine_x = {
                    {
                        function()
                            local clients = vim.lsp.get_clients({ bufnr = 0 })
                            if next(clients) == nil then return "No client" end
                            return clients[1].name
                        end,
                    },
                },
                lualine_y = {
                    { "location", },
                },
                lualine_z = {
                    { "progress", },
                },
            },
        })
    end,
}
