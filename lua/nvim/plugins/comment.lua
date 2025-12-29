-- Plugin used to facilitate the task of comment and uncomment easily and simpler.
return {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },


    config = function()
        local comment = require("Comment")

        comment.setup({
            -- Funcion que se llamara ANTES de comentar/dscomentar
            pre_hook = function(ctx)
                -- Si estás en modo de bloque (ej. con Treesitter), usa el comentario de bloque
                local U = require('Comment.utils')
                -- Si estamos comentando una línea, usar '//' para C
                if ctx.ctype == U.ctype.line then
                    return '// %s'  -- Comentario de línea en C: // comentario
                end

                if ctx.ctype == U.ctype.block then
                    -- Agregar el comentario en bloque con "/* */"
                    return '/*%s*/'
                end
            end,

            -- Comentar/Descomentar la linea/bloque actual sin entrar en modo operador
            toggler = {
                line = '<leader>c',  -- Atajo para comentar/descomentar una línea
                block = '<leader>C', -- Atajo para comentar/descomentar un bloque
            },
            -- Comentar/Descomentar la linea/bloque actual en modo operador.
            --[[ El modo operador es un modo intermedio que se activa en VIM después
                 de escribir un operador, y antes de indicar sobre que se aplica ]]
            opleader = {
                line = '<leader>c',  -- Atajo para comentar en modo visual (línea)
                block = '<leader>C', -- Atajo para comentar en modo visual (bloque)
            },
        })
    end

}
