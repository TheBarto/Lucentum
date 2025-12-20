return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio"
	},
	config = function()
		--[[local cpptools_path = vim.fn.expand("~/.local/share/cpptools")
		local opendebug = cpptools_path .. "/debugAdapters/bin/OpenDebugAD7"

		if vim.fin.executable(opendebug) == 0 then
			vim.notify("Installing OpenDebugAD7...", vim.log.levels.INFO)
			vim.fn.system({
				"git", "clone",
				"https://github.com/microsoft/vscode-cpptools",
				cpptools_path,
			})
		end]]

		local dap = require("dap")
		local dapui = require("dapui")

		local function has_gdb_dap()
			local handle = io.popen("gdb --version 2>/dev/null")
			if not handle then
				return false
			end

			local output = handle:read("*a")
			handle:close()

			local major = output:match("GNU gdb %D*(%d+)")
			major = tonumber(major)

			return major and major >= 14
		end

		local function pick_adapter()
			if has_gdb_dap() then
				return "gdb"
			end
			return "cppdbg"
		end

		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
		}

		dap.adapters.cppdbg = {
			id = "cppdbg",
			type = "executable",
			command = vim.fn.expand("~/.local/share/cpptools/debugAdapters/bin/OpenDebugAD7"),
		}

		dap.configurations.c = {
			{
				name = "Launch file (auto:gdb-dap / cppdbg)",
				type = pick_adapter,
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
				end,
				-- args = {}, -- provide arguments if needed
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = true,
				stopAtEntry = true,  -- Para que se detenga al inicio de la ejecucion

				MIMode = "gdb" -- Solo usado por cppdbg
			},
			{
				name = "Select and attach to process (auto:gdb-dap / cppdbg)",
				type = pick_adapter,
				request = "attach",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				pid = function()
					local name = vim.fn.input('Executable name (filter): ')
					return require("dap.utils").pick_process({ filter = name })
				end,
				cwd = '${workspaceFolder}'
				stopAtBeginningOfMainSubprogram = true,
				stopAtEntry = true,

				MIMode = "gdb" -- Solo usado por cppdbg
			},
			{
				name = 'Attach to gdbserver :1234  (auto:gdb-dap / cppdbg)',
				type = pick_adapter,
				request = 'attach',
				target = 'localhost:1234',
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}'
				stopAtBeginningOfMainSubprogram = true,
				stopAtEntry = true,

				MIMode = "gdb" -- Solo usado por cppdbg
			}
		}

		-- Cargamos la configuracion tambien para C++
		dap.configurations.cpp = dap.configurations.c

		require("dapui").setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<F5>",  function() dap.continue() end, { desc = "Iniciar/Continuar depuracion" })
		vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Step Over" })
		vim.keymap.set("n", "<F11>", function() dap.setp_into() end, { desc = "Step Into" })
		vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Step Out" })
		vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })

		-- Asegurar estos comandos antes de descomentarlos
		--[[vim.keymap.set("n", "<Leader>B", function()
			dap.set_breakpoint(vim.fn.input("Condicion del breakpoint: "))
		end, { desc = "Breakpoint condicional" })
		vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end, { desc = "Abrir REPL" })
		vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end, { desc = "Repetir última sesión" })
		vim.keymap.set("n", "<Leader>du", function() dapui.toggle() end, { desc = "Alternar interfaz DAP-UI" })]]
	end,
}
