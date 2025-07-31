-- When open neovim, the scripts on these folders will be used

-- Every name is a folder. The '.' is the separator of the different
-- levels.
require("nvim.core")
require("nvim.lazy")

-- If we have a format plugin, and we want to used it, we must create a
-- file called '.clang-format' at the neovim's configure root folder. If
-- we want a specific format file, we must create a configure file, with
-- the same name at the proyect folder.
