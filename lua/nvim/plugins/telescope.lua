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

-------------------------------------------------------------------------------------
        local tel = require("telescope.builtin")

        local function get_position_params()
          local client = vim.lsp.get_clients({ bufnr = 0 })[1]
          local encoding = client and client.offset_encoding or "utf-16"

          return vim.lsp.util.make_position_params(0, nil, {
            encoding = encoding,   -- ← ESTE es el parámetro correcto en NVIM 0.12
          })
        end

        local function open_location_in_split(location)
          local uri = location.uri or location.targetUri
          local range = location.range or location.targetRange
          local fname = vim.uri_to_fname(uri)

          vim.cmd("split " .. fname)

          local row = range.start.line + 1
          local col = range.start.character
          vim.api.nvim_win_set_cursor(0, { row, col })
        end

        local function request_lsp(method)
          local params = get_position_params()
          local results = vim.lsp.buf_request_sync(0, method, params, 500)
          if not results then return {} end

          local locations = {}

          for _, res in pairs(results) do
            local result = res.result
            if result then
              if vim.islist(result) then
                vim.list_extend(locations, result)
              else
                table.insert(locations, result)
              end
            end
          end

          return locations
        end

        local function jump_or_telescope(method, telescope_fn)
          local locations = request_lsp(method)

          if #locations == 0 then
            return false
          end

          if #locations == 1 then
            open_location_in_split(locations[1])
            return true
          end

          telescope_fn({ jump_type = "split" })
          return true
        end

        local function smart_lsp_jump()
          if jump_or_telescope("textDocument/definition", tel.lsp_definitions) then return end
          if jump_or_telescope("textDocument/typeDefinition", tel.lsp_type_definitions) then return end
          if jump_or_telescope("textDocument/declaration", tel.lsp_declarations) then return end

          vim.notify("No LSP locations found", vim.log.levels.WARN)
        end

        local function grep_word_under_cursor()
          local word = vim.fn.expand("<cword>")
          if word == "" then return end
          local ok, telescope = pcall(require, "telescope.builtin")
          if not ok then return end

          local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
          if root == "" then
           root = vim.loop.cwd()
          end

          telescope.grep_string({
            search = word,
            search_dirs = { root },
            additional_args = function()
              return { "--no-ignore", "-F" }
            end,
          })
        end

-- Función para buscar un string en todo el proyecto (incluye submódulos)
-- Posibilidad de mejora en varios aspectos:
-- activar modo "exact macth"
-- añadir un selector de flags
-- ignorar carpetas especiales
-- detectar si rg está instalado

-- Permite buscar expresiones completas, multiples palabras, expresiones regulares
        local grep_project_string = function()
          vim.ui.input({ prompt = "Buscar en proyecto: " }, function(query)
            if not query or query == "" then
              return
            end

            -- Detecta si contiene caracteres típicos de regex
            local is_regex = query:find("[.%*%+%?%[%]%^%$|%(%)]")

            require("telescope.builtin").live_grep({
              default_text = query,
              additional_args = function(_)
                local args = {
                  "--hidden",        -- opcional
                  "--no-ignore",     -- opcional
                  "--smart-case",    -- como live_grep
                }

                if not is_regex then
                  table.insert(args, "-F")
                end

                return args
                end,
              })
          end)
        end

        -- Load the fzf extension to have better performance
        telescope.load_extension("fzf")

        --set custom keymaps
        local keymap = vim.keymap --load the current keymap set

        -- "n" is for normal mode
        keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Fuzzy find files in cwd" })
        keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Fuzzy find recent files" })
        keymap.set("n", "<leader>fs", grep_project_string,            { desc = "Find string in cwd" })
        keymap.set("n", "<leader>fg", grep_word_under_cursor,         { desc = "Find string under cursor in current proyect or cwd if no proyect" })
        --keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   { desc = "Find string in cwd" })
        --keymap.set("n", "<leader>fg", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
        keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>",         { desc = "Find todos" })


        -- This are for searching definitions, references, symbols inside the proyect.
        keymap.set("n", "<leader>fD", "<cmd>Telescope lsp_definitions<cr>",      { desc = "Find the definition of the function under the cursor" })
        keymap.set("n", "<leader>fR", "<cmd>Telescope lsp_references<cr>",       { desc = "Find all the references of the element under the cursor" })
        keymap.set("n", "<leader>fS", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find symbols in cwd" })
        keymap.set("n", "<leader>fI", "<cmd>Telescope lsp_implementations<cr>",  { desc = "Show elements(functions) implementations"})
        --keymap.set("n", "<leader>fT", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Find the TYPE DEFINITION of a structure/array/..."})
        -- keymap.set("n", "<leader>fT", clangd_smart_type, {desc = "Smart type search"})
        keymap.set("n", "<leader>fT", smart_lsp_jump, {desc = "Smart type search"})
    end,
}
