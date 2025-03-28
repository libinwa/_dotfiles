# My dotfiles

`git clone --depth=1 https://github.com/libinwa/_dotfiles.git`

## vimrc

> My vimrc, plugins configured in .vim-plugins.vim script file based vim-plug manager.

Simply `source path/to/_dotfiles/_vimrc` to load this vimrc. 
Or
1. Switch your working directory to your `$HOME`
2. Copy file `_dotfiles/_vimrc` to your `$HOME`


## Navigating file system quickly

when [fzf](https://github.com/junegunn/fzf) and [fd](https://github.com/sharkdp/fd) are executable on your env, adding env variables:

```
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
```

try:
- Press `<CTRL-T>` To fuzzily select a file or directory
- Press `<ALT-C>` To fuzzily change current directory
- Press `<CTRL-R>` To fuzzily search CLI history

> fd is designed to search for files by name, [rg](https://github.com/BurntSushi/ripgrep) is designed to search the contents of files. 
> But ripgrep can be used to search for files by name rather than contents. 

