-- Add some functionality to interact with the TODO comments of the LSP server.
-- Allow navigate with the code's errors and see them.
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim",
        "nvimtools/hydra.nvim" },
  opts = {
    focus = true,
  },
  --cmd = "Trouble",

  config = function()
  local hydra = require("hydra")
  local trouble = require("trouble")

	trouble_hint = [[
		_o_: Open trouble workspace diagnostics
		_d_: Open trouble document diagnostics
		_q_: Open trouble quickfix list
		_l_: Open trouble location list
		_t_: Open todos in trouble
		_<Esc>_: Exit
	]]
  hydra({
		name = "Trouble",
		hint = trouble_hint,
		mode = "n",
		body = "<leader>x",
		config = {
			invoke_on_body = true,
		},
		heads = {
			{ 'o', function() trouble.toggle("diagnostics") end, { exit = true, desc = "Workspace diagnostics" } },
			{ 'd', function() trouble.toggle("diagnostics", { filter = { buf = 0 } }) end, { exit = true, desc = "Document diagnostics" } },
			{ 'q', function() trouble.toogle("quickfix") end, { exit = true, desc = "Quickfix list" } },
			{ 'l', function() trouble.toogle("loclist") end, { exit = true, desc = "Location list" } },
			{ 't', function() trouble.toogle("todo") end, { exit = true, desc = "TODOs" } },
			{ "<Esc>", nil, { exit = true } },
		},
	})
	end
	--[[ keys = {
    { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
  }, ]]
}

