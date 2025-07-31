-- Plugin to format the code using differents formatters.
-- We can use differents formatters for that use.
-- clang-format is a formatter for C/C++
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters = {
        -- Registrar clang-format como formateador
        c = { 'clang-format' },  -- Usa clang-format para C
        cpp = { 'clang-format' },  -- También para C++
        h = { 'clang-format' },  -- También para C
        hpp = { 'clang-format' },  -- También para C++
      },
      
      lsp = {-- Desactivar el formateo automatico al guardar
        format_on_save = false,
        --format_on_save = {
        --  lsp_fallback = true,
        --  async = false,
        --  timeout_ms = 1000,
        --},
      },
    })

    -- Formateo empleando el lsp client con comando.
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        -- Realiza el formateo de manera asincrona, sin bloquear la interfaz de usuario
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
