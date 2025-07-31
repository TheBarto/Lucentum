-- These lines do the installation of the lazy nvim plugin manager
-- if it is not installed, when we open neovim. If it is installed
-- nothing will happens.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
-- With this line we just say get the lazy plugin and use the sripts from that folder.
require("lazy").setup({{ import = "nvim.plugins"},{import="nvim.plugins.lsp"}}, {
    -- Deactivate the notifications
    change_detection = {
        notify = false,
    },
    -- Set at the lua line infomation about the different plugin status
    checker = {
        enabled = true,
        notify = false,
    },
})
