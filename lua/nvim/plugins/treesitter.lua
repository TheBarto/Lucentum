-- This plugin add cool things about highlighted, automatic indentation,
-- LSP integration, syntax text selection, ...
return {
    "nvim-treesitter/nvim-treesitter",
    -- Only when open an already existing file or a new file
    event = { "BufReadPre", "BufNewFile" },
    -- Execute when this plugin is installed or updated
    build = ":TSUpdate",
    -- Helps to close tag and functions automatically
    dependencies = {
        "windwp/nvim-ts-autotag",
    }, 

    config = function()
        local treesitter = require("nvim-treesitter.configs")

        -- configure the treesitter plugin
        treesitter.setup({
            -- enable syntax highlighting
            highlight = { enable = true },

            -- enable indentation
           indent = { enable = true },

           -- enable autotagging (w/ nvim-ts-autotag plugin)
           autotag = { enable = true },

           -- enable these languages parsers are installed
           -- Con esto aseguramos que todos los parseadores
           -- de lenguajes que queramos se encuentran instalados.
           -- Visitar la wiki/pagina web de treesitter y ver
           ensure_installed = {"c", "cpp", "objc", "cuda", "cmake", "vimdoc", "vim",
                               "bash", "gitignore", "asm", "python", "make", "doxygen",
                               "diff", "awk", "ninja", "doxygen", "comment",
                               "json", "yaml", "toml" },

           incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
