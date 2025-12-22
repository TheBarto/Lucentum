return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-telescope/telescope.nvim",
		"nvim-telescope/telescope-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		local function get_gdb_version()
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
			if get_gdb_version() then
				return "gdb"
			end
			return "cppdbg"
		end

		--[[Para que GDB funcione con DAP es necesario que su version sea >= GDB 14.
			En otro caso fallará.]]
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
		}

		--[[Adaptador para cppdbg. En caso de que falle GDB, podemos emplear esta version,
			que emplea un adaptador generado por Windows para comunicarse con el debugger
			en caso de que este no disponga de adaptador DAP.

			Para instalarlo hay que ir al github de microsoft (https://github.com/microsoft/vscode-cpptools),
			y seleccionar en las releases -> "Latest". Una vez aqui, hay que buscar cpptools-linux-x64.vsix
			(o la arquitectura que tengamos en el sistema).

			Una vez descargado, simplemente pasamos el formato a zip, y lo descomprimimos.
			De todos los archivos que vienen, tenemos que buscar OpenDebugAD7, copiarlo en
			el directorio indicado abajo y darle permisos de ejecución para el usuario,
			y con eso ya tendríamos todo fijado.]]
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
				cwd = '${workspaceFolder}',
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
				cwd = '${workspaceFolder}',
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

		local dapuitext = require("nvim-dap-virtual-text")
		dapuitext.setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = true,  -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			commented = false, -- prefix virtual text with comment string
			show_stop_reason = true, -- show stop reason when stopped for exceptions

			display_callback = function(variable, buf, stackframe, node, options)
			--by default, strip out new line characters
				if options.virt_text_pos == 'inline' then
					return ' = ' .. variable.value:gsub("%s+", " ")
				else
					return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
				end
			end,

			virt_text_pos = get_gdb_version() and 'eol' or 'inline',
		})

		vim.fn.sign_define("DapStopped", {
		--	text = "",
			texthl = "DapStopped",
			linehl = "DapStoppedLine",
			numhl =  "DapStoppedLine",
		})

		-- Para que la linea en donde estemos parados resalte mas
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#E31414" })
				vim.api.nvim_set_hl(0, "DapStopped", { bg = "#E31414" })
			end,
		})

		local telescope = require("telescope")
		telescope.load_extension("dap")

		-- Telescope DAP keymaps
		-- Listamos todos los breakpoints.
		vim.keymap.set("n", "<leader>db",
			function() telescope.extensions.dap.list_breakpoints() end,
			{ desc = "DAP: Listar breakpoints" }
		)

		-- Muestra el stack de llamadas (backtrace) del
		-- programa cuando este se encuentra detenido.
		vim.keymap.set("n", "<leader>df",
			function() telescope.extensions.dap.frames() end,
			{ desc = "DAP: Stack frames" }
		)

		-- Abre una lista para visualizar todas las
		-- variables visibles en el scope actual
		vim.keymap.set("n", "<leader>dv",
			function() telescope.extensions.dap.variables() end,
			{ desc = "DAP: Variables" }
		)

		-- Lista todos los comandos DAP disponibles en el momento de ejecutarlo
		vim.keymap.set("n", "<leader>dc",
			function() telescope.extensions.dap.commands() end,
			{ desc = "DAP: Comandos" }
		)

		vim.keymap.set("n", "<F5>",  function() dap.continue() end, { desc = "Iniciar/Continuar depuracion" })
		vim.keymap.set("n", "<F6>", function() dap.step_over() end, { desc = "Step Over" })
		vim.keymap.set("n", "<F7>", function() dap.step_into() end, { desc = "Step Into" })
		vim.keymap.set("n", "<F8>", function() dap.step_out() end, { desc = "Step Out" })
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
