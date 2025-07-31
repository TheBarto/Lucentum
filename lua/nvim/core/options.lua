vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- relative number of lines & line number
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4    -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.softtabstop = 4 -- 4 spaces when tab key is pressed
opt.expandtab = false -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true

--search settings
opt.ignorecase = true -- ignore case sensitive searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive
opt.incsearch = true -- al realizar busquedas, que vaya subrayando con busquedas incrementales
opt.cursorline = true -- highline the current line

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use any true color scheme terminal)
opt.termguicolors = true
--opt.background = "dark" -- colorschemes that can be light or dark will be dark
--opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace (retroceso)
--opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard. Use the system clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.cc = "80" -- Set a marked at the 80th column

-- Dejar siempre 10 lineas por encima/debajo al desplazarnos.
-- A menos que lleguemos a los limites del fichero
opt.scrolloff = 10
opt.list = true

opt.lazyredraw = true
opt.updatetime = 250

-- Representa los caracteres ocultos como simbolos
opt.listchars = {
	tab = " \\",
	space = ".",
	eol = "↲"
}

-- Configuramos vim para que NO almacene archivos swaps ni backups, pero
-- configuramos el plugin undo tree para que almacene informacion de los
-- cambios. Tendremos informacion de los undos de hace dias.
opt.swapfile = false
opt.backup = false
--opt.undodir = "~/.vim/undodir"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Recordar vaciarla cada x dias/meses
opt.undofile = true

-- Con esto indicamos a NVIM que solamente fije una barra de estado.
-- Con valor: 0 nunca la mostrara, 1 solo se muestra con 2 ventanas
-- 2 una barra de estado para cada ventana, 3 una sola barra de estado
-- para todas las ventanas.
opt.laststatus = 3
