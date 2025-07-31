-- This file will be used to setup plugins that don't require to much configuration

-- The plugins will be obtained from git hub repositories. The first part is
-- the user who made the plugin and the second is the name of the plugin itself

-- After setting here the plugins, you must open the Lazy plugin (:Lazy)
-- and install them, with the 'I' option.
return {
    "nvim-lua/plenary.nvim", -- lua functions that many plugins use
    "christoomey/vim-tmux-navigator", -- tmux &split window navigation
}

