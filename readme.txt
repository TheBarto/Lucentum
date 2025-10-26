* Neovim include by default a LSP client, but you can include configuration plugin like "nvim-lspconfig". With this plugin we can configurate the behaviour of the LSP client plugin. The LSP client comes installed from the 0.5 Neovim's version. To install it we must use the Lazy plugin and use a lua plugin.

* The LSP server for C is clangd. This allow to have the same functionallity as a programming IDE. To install it we have to install it using the apt-get tool: $sudo apt-get install clangd. Tras instalarlo comprobamos cual es la versión usando $clangd --version

To know how to compile the code, the clangd server needs a special file in which all the project compilation information will be specified. This file will help the clangd to obtain all the information. To generate it there is 2 ways: 

   - Using CMAKE -> "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build". This will generate the file compile_commands.json. $sudo apt-get install cmake
   - Using bear  -> "bear -- make". This will generate the compile_commands.json. $sudo apt-get install bear

Both ways generate the "compile_commands.json" file, which helps the clangd server, must be at the root of the project. It is important to situate the file at the root project folder, otherwise it won't work.


* To have a specific format, it is necessary install another plugin, one that uses a formatter to set the code with an specific/desired format. With this plugin we can set the format with a command, or at the moment of saving, allowing us to have a share global code format. This plugin is "conform.lua".
The plugin uses a formatter to format the code. For C/C++ the formatter is "clang-format". To install this plugin it is mandatory use the command: $sudo apt-get install clang-format.

After installed the formatter it is necessary create a file with the instructions/directives to format the code. This file must be called ".clang-format" and must be situated at the proyect root (like the compile_commands.json).


* It's also recommendable install git. For that it is necessary use the command: $sudo apt-get install git.
After install it is mandatory to configure it:
	- git config --global user.name <Tu Nombre>              -> Configure the Git user's name
	- git config --global user.email <tuemail@ejemplo.com>   -> Configure your email
	- git config --list                                      -> Shows your current configuration


* To customize the linux terminal prompt, it is necessary modify the .basrc file, at the user's home directory. At the end of the file the PS1 variable must be modified, exporting it:

"""
parse_git_branch()
{
git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# PS1='${debian_chroot:+($debian_chroot)}[\033[01;32m]\u@\h[\033[00m]:[\033[01;34m]\w[\033[01;31m]$(parse_git_branch)[\033[00m]\$'
export PS1="\e[1;32m\u\e[0m@\e[1;31m\H\e[0m//\e[1;34m\w\e[0m\e[1;36m\$(parse_git_branch)\e[0m > \n"
"""

With this configuration we will print: current user@device's name//current_work_directory. The command will we type at the next line.
If the current working directory has a git repository, the repository name will be also displayed at the prompt line.

These two webs explain everything needed to understand all the symbols:
https://www.linkedin.com/pulse/transform-your-terminal-step-by-step-guide-show-git-branch-eking
https://phoenixnap.com/kb/change-bash-prompt-linux

* To add custom font elements to the system, this must be downloaded from the git repository: https://github.com/ryanoasis/nerd-fonts/releases. After select and download the desired zip font, we must install it. For that the compress file must be uncompress at the following location:
	- ~/.local/share/fonts
After all the .ttf files are located at that folder, we must execute the following command, to add the new fonts:
	- fc-cache -fv

With this now we can use the following fonts, but only at the user we set them. For use it at Linux, you must configure the terminal to use the new fonts selected.

To use it at Windows Subsystem for Linux (WSL), you must install the fonts at the Windows System. For that you must select all the .ttf files and click at install for all users/install them. After that, we have all the fonts install them in Windows. Now at the Window's Power Shell, click at the down arrow, and select 'Configure'.

At the profile menu, select the 'Default Values' and 'Appearance'. Now at the font type sub-menu, select the desired font, save and restart the WSL terminal.

This can be searched at Google, or just go to: https://dev.to/erickvasm/como-personalizar-neovim-3gg8. It explains these steps quite good.

* To compare files meld program could be use. This program allows you to compare files and folders. To install it: $sudo apt-get install meld
