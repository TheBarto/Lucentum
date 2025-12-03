-- LSP server client. By default vim does not include it. With this client
-- we can comunicate with the instaled server and send it commands to execute
-- differents LSP actions
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" }, -- Solo necesario cuando estemos en un fichero
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Integra el autocompletado con los servidores
    -- Añade funcionalidad extra, como modificar import, include cuando el fichero se renombre
    { "antosha417/nvim-lsp-file-operations", config = true }, 
    -- Añade mejoras a la funcionalidad de LSP para la configuracion de Neovim 
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import mason_lspconfig plugin
    -- local mason_lspconfig = require("mason-lspconfig")

    vim.lsp.config("clangd", {
      cmd = {
        "clangd",
        "--background-index",        -- indexa mientras editas (muy rápido)
        "--completion-style=detailed",
        "--clang-tidy",              -- análisis automático de errores
        "--all-scopes-completion",
        "--header-insertion=iwyu",
        "--pch-storage=memory",
        "--offset-encoding=utf-16",  -- necesario para Neovim 0.11
        "--fallback-style=llvm",
        "--log=error",
      },
    })

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds. Solo disponibles cuando un cliente se "añada" a un buffer (fichero)
        --opts.desc = "Show LSP references"
        --keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        --opts.desc = "Show LSP definitions"
        --keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        --opts.desc = "Show LSP implementations"
        --keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        --opts.desc = "Show LSP type definitions"
        --keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    -- end
    vim.diagnostic.config({
       signs = {
          text = {
                  [vim.diagnostic.severity.ERROR] = " ",
                  [vim.diagnostic.severity.WARN] = " ",
                  [vim.diagnostic.severity.INFO] = "󰠠 ",
                  [vim.diagnostic.severity.HINT] = " ",
          },
          texthl = {
                    [vim.diagnostic.severity.ERROR] = "Error",
                    [vim.diagnostic.severity.WARN] = "Warning",
                    [vim.diagnostic.severity.INFO] = "Info",
                    [vim.diagnostic.severity.HINT] = "Hint",
          },
          numhl = {
                   [vim.diagnostic.severity.ERROR] = "",
                   [vim.diagnostic.severity.WARN] = "",
                   [vim.diagnostic.severity.INFO] = "",
                   [vim.diagnostic.severity.HINT] = "",
          },
       },
    })

    -- Forma de configurar los servidores de lenguaje.
    vim.lsp.config.clangd = {
          -- Configura la forma en que se ejecuta clangd en neovim.
          -- background-index: genera un indice global en segundo plano para encontrar referencias mas rapido.
          --       Se almacena en ~/.cache/clangd/
          -- clangd-tidy habilita cland-tidy, una herramienta de analisis estático para encontrar problemas en el codigo.
          -- header-insertion=never desactiva la inserción autmática de #include en autocompletado. 
          cmd = {"clangd", "--background-index", "--clang-tidy", "--header-insertion=never"},
          filetypes = { "c", "cpp", "h", "objc", "objcpp" },
          -- root_pattern busca archivos/carpetas en la jerarquia de directorios.
          -- Lo que hace es buscar un fichero "compile_commands.json" en el directorio DONDE SE HA ABIERTO EL FICHERO, y si no lo encuentra va subiendo niveles y lo sigue buscando.
          -- Si no lo encuentra, entonces pasa a buscar, usando el mismo proceso, con .git (carpeta)
          root_dir = vim.fs.root(0, { "compile_commands.json", ".git" }),
          settings = { 
            -- Mostrar el estado de clangd en el cliente
            clangd = {clangdFileStatus = true,},
          },
          capabilities = capabilities,
    }
    -- mason_lspconfig.setup_handlers({
    --   -- default handler for installed servers
    --   function(server_name)
    --     lspconfig[server_name].setup({
    --       capabilities = capabilities,
    --     })
    --   end,
    --   ["clangd"] = function()
    --     -- configure clangd language server
    --     lspconfig["clangd"].setup({
    --       capabilities = capabilities,
    --       filetypes = { "c", "cpp", "h", "objc", "objcpp" },
    --       settings = { 
    --         -- Mostrar el estado de clangd en el cliente
    --         clangd = {clangdFileStatus = true,},
    --       },
    --       -- Configura la forma en que se ejecuta clangd en neovim.
    --       -- background-index: genera un indice global en segundo plano para encontrar referencias mas rapido.
    --       --       Se almacena en ~/.cache/clangd/
    --       -- clangd-tidy habilita cland-tidy, una herramienta de analisis estático para encontrar problemas en el codigo.
    --       -- header-insertion=never desactiva la inserción autmática de #include en autocompletado. 
    --       cmd = {"clangd", "--background-index", "--clang-tidy", "--header-insertion=never"},
    --
    --       -- root_pattern busca archivos/carpetas en la jerarquia de directorios.
    --       -- Lo que hace es buscar un fichero "compile_commands.json" en el directorio DONDE SE HA ABIERTO EL FICHERO, y si no lo encuentra va subiendo niveles y lo sigue buscando.
    --       -- Si no lo encuentra, entonces pasa a buscar, usando el mismo proceso, con .git (carpeta)
    --       root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
    --     })
    --   end,
    -- })
    -- Activar el servidor
    vim.lsp.enable("clangd")
  end,
}

