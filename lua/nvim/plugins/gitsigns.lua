-- Shows and interacts with Git information directly from Neovim
return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "nvimtools/hydra.nvim", },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- Cargar las opciones para configurar el plugin como queramos
    current_line_blame = true, -- Blame automático activado globalmente
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align", -- Alineado a la derecha
      delay = 0,                     -- Sin retraso
      ignore_whitespace = false,
    },
    -- current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    -- Los argumentos los obtuve de ChatGPT
    current_line_blame_formatter = function(name, blame_info)
      -- name contiene el nombre del autor del cambio
      -- blame_info es una tabla que contiene toda la informacion sobre el cambio
      local date = os.date("%d/%m/%Y", blame_info.author_time)
      local line = string.format("%s-%s-%s", blame_info.author, date, blame_info.summary:sub(1,30))
      return { { line, "Comment" } }
    end,

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local hydra = require("hydra")

      gitsigns_hints = [[
		NVIM GITSIGNS
		_a_: do stage hunk (git add)
		_u_: undo stage hunk (undo git add, mantain the changes)
		_r_: reset stage (undo the changes that create the hunk)
		_b_: blame line
		_n_: next hunk
		_p_: previous hunk
		_A_: do stage for all hunks (git add for ALL hunks)
		_R_: reset for all hunks (undo the changes for ALL hunks)
		_P_: compare the hunk's changes with the original element
		_<Esc>: quit
	  ]]

	hydra({
		name = "Git Signs",
		hint = gitsigns_hints,
		mode = "n",
		body = "<leader>g",
		config = {
			invoke_on_body = true,
			hint = {
				type = "window",
				position = "bottom",
			},
		},
		heads = {
			{ 'a', gs.stage_hunk, { desc = "do stage hunk" } },
			{ 'u', gs.undo_stage_hunk, { desc = "undo stage hunk" } },
			{ 'r', gs.reset_hunk, { desc = "reset hunk " } },
			{ 'b', gs.toggle_current_line_blame, { desc = "blame lines"} },
			{ 'n', gs.next_hunk, { desc = "next hunk" } },
			{ 'p', gs.prev_hunk, { desc = "previous hunk" } },
			{ 'A', gs.stage_buffer, { desc = "stage ALL hunks " } },
			{ 'R', gs.reset_buffer, { desc = "reset ALL hunks " } },
			{ 'P', gs.preview_hunk, { desc = "preview hunk" } },
			{ "<Esc>", nil, { exit = true, desc = "Exit" } },
		}
	})
      --[[local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      -- Git Next -> Next Hunk
      map("n", "gn", gs.next_hunk, "Next Hunk")
      -- Git Previous -> Previuos hunk
      map("n", "gp", gs.prev_hunk, "Prev Hunk")

      -- Actions
      -- Git Add -> Add the stage to the local branch
      map("n", "<leader>ga", gs.stage_hunk, "Stage hunk (make git add)")
      -- Deshace el ultimo git add realizado. Deshacemos los git add.
      map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk (undo git add)")
      -- Git Reset -> To undo the stage of the local branch, before staging it
      map("n", "<leader>gr", gs.reset_hunk, "Reset hunk (undo the changes that create the hunk)")
      -- LO MISMO PERO PARA EL MODO VISUAL
      map("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage hunk")
      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset hunk")

      -- Git Add para todo el fichero
      map("n", "<leader>gA", gs.stage_buffer, "Stage buffer (git add to all hunks)")
      -- ESTOS CAMBIOS QUE ELIMINA SON CON RESPECTO AL ORIGINAL. TIENE QUE HACERSE ANTES DE HACER UN
      -- git add, DE OTRA FORMA PRIMERO TENDRÁ QUE HACERSE UN <leader>hu PARA ELIMINAR TODOS LOS
      -- CAMBIOS SUBIDOS.
      -- Git Reset para todos los cambios. NO DEBEN DE HABERSE "SUBIDO" CON GIT ADD
      map("n", "<leader>gR", gs.reset_buffer, "Reset buffer (undo ALL the hunks, eliminate all changes)")

      -- Permite visualizar las diferencias de un hunk con respecto al original.
      map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")

      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, "Blame line (like git log over one line -> VISUAL MODE)")
      -- gB es como hb, pero muestra quien hizo el cambio para cada linea.
      -- Es un git log para cada linea. Al posarte sobre una muestra la informacion de esta.
      --map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
      map("n", "<leader>gB", gs.toggle_current_line_blame,
          "Blame line (like git log over one line -> VISUAL MODE)")

      -- Hace un diff con el archivo original de git. El que tiene los cambios
      -- se mostrara en la ventana izquierda, el del servidor en la derecha.
      map("n", "<leader>gd", gs.diffthis, "Diff this with the original")
      -- map("n", "<leader>gD", function()
      --   gs.diffthis("~")
      -- end, "Diff this ~")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")]]
    end,
  },
}

