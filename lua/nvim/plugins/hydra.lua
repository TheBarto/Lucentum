return {
    "nvimtools/hydra.nvim",

config = function()
local Hydra = require("hydra")
local split_hint = [[
      Split Windows Options

  _v_: split windows vertically
  _h_: split windows horizontally
  _e_: make windows splits equal size
  _c_: close current windows split

]]

	Hydra({
		name = "Windows Splits",
		hint = split_hint,
		mode = "n",
		body = "<leader>s",
		config = {
			invoke_on_body = true,
			hint = {
				type = "window",
				position = "bottom",
			},
		},
		heads = {
			{ 'v', function() vim.api.nvim_command("vsplit") end, { desc = "Split window vertically" } },
			{ 'h', function() vim.api.nvim_command("split") end, { desc = "Split window horizontally" } },
			{ 'e', function() vim.api.nvim_command("wincmd =") end, { desc = "Make splits equal size" } },
			{ 'c', function() vim.api.nvim_command("close") end, { desc = "Split window vertically" } },
		},
	})

local tab_hint = [[
      Tab Windows Options

  _o_: open new empty tab
  _c_: close tab
  _n_: go to the next tab
  _p_: go to the previous tab
  _f_: open new tab with the current buffer
]]
	Hydra({
		name = "Tab Splits",
		hint = tab_hint,
		mode = "n",
		body = "<leader>t",
		config = {
			invoke_on_body = true,
			hint = {
				type = "window",
				position = "bottom",
			},
		},
		heads = {
			{ 'o', function() vim.api.nvim_command("tabnew") end, { desc = "Split window vertically" } },
			{ 'c', function() vim.api.nvim_command("tabclose") end, { desc = "Split window horizontally" } },
			{ 'n', function() vim.api.nvim_command("tabn") end, { desc = "Make splits equal size" } },
			{ 'p', function() vim.api.nvim_command("tabp") end, { desc = "Split window vertically" } },
			{ 'f', function() vim.api.nvim_command("tabnew %") end, { desc = "Split window vertically" } },
		},
	})
	end,
}
