-- Setting the leader key.
vim.g.mapleader = " "

-- Setting the vim key map as the default
local keymap = vim.keymap

-- With this line you can define your own keymap settings.
-- 1º argumento -> "i" indica el modo donde se desarrolla el cmd. En este caso el modo insert
-- 2º argumento -> combinacion de teclas para ejecutar el cmd
-- 3º argumento -> accion que se ejecutara en el cmd
-- 4º argumento -> descripcion del comando
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })


-- Tras realizar una busqueda, para eliminar TODO los elementos subrayados, incluimos este comando. 
keymap.set("n", "<leader>n", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
-- fija un numero, y en modo comando, posandonos sobre el y pulsando tecla leader (espacio)
-- y "+" aumentamos su valor o "-" disminuimos el valor
--keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
--keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

--[[

  _o_: open new tab
  _c_: close current tab
  _n_: go to the next tab
  _p_: go to the previous tab
  _f_: open current buffer into a new tab
]]
-- window management. s(split)
--keymap.set("n", "<leader>sv", "<C-W>v", {desc = "Split window vertically"})     -- split window vertically
--keymap.set("n", "<leader>sh", "<C-W>s", {desc = "Split window horizontally"})   -- split window horizontally
--keymap.set("n", "<leader>se", "<C-W>=", {desc = "Make splits equal size"})      -- make split windows equal width
--keymap.set("n", "<leader>sc", "<cmd>close<CR>", {desc = "Close current split"}) -- close current split window

-- tabs management. t(tab)
--keymap.set("n", "<leader>to", "<cmd>tabnew<CR>",   {desc = "Open new tab"})                   -- Open new tab
--keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", {desc = "Close current tab"})              -- Close current tab
--keymap.set("n", "<leader>tn", "<cmd>tabn<CR>=",    {desc = "Go to next tab"})                 -- Go to next tab
--keymap.set("n", "<leader>tp", "<cmd>tabp<CR>",     {desc = "Go to previous tab"})             -- Go to previous tab
--keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {desc = "Open current buffer in new tab"}) -- Open the current file in another tab (same file in two tabs)

-- recargar configuracion de Neovim sin estar cerrandolo con F5.
-- keymap.set("n", "<F5>", ":source $MYVIMRC<CR>", {noremap = true, silent = true})

