" Specify a directory for plugins
call plug#begin(PackHome())
"
" List the plugins with Plug commands
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'yegappan/lsp'
Plug 'puremourning/vimspector'
Plug 'Freed-Wu/cppinsights.vim'
Plug 'girishji/devdocs.vim'
Plug 'diepm/vim-rest-console'
call plug#end()
" INITIALIZATION OF PLUGINs

"
" Settings Plug 'yegappan/lsp'
"
"{
let lspServers = []
if executable('clangd')
  let lspServers += [#{ name: 'clang', filetype: ['c', 'cpp'], path: 'clangd', args: ['--background-index', '--log=verbose'] }]
endif
if executable('rust-analyzer')
  let lspServers += [#{ name: 'rustlang', filetype: ['rust'], path: 'rust-analyzer', args: [], syncInit: v:true }]
endif
if executable('lua-language-server')
  let lspServers += [#{ name: 'lua', filetype: ['lua'], path: 'lua-language-server', args: [] }]
endif
if executable('pylsp')
  let lspServers += [#{name: 'pylsp', filetype: 'python', path: 'pylsp', args: [] }]
endif
if executable('neocmakelsp-x86_64-pc-windows-msvc')
  let lspServers += [#{name: 'neocmakelsp', filetype: 'cmake', path: 'neocmakelsp-x86_64-pc-windows-msvc', args: ['--stdio', '-v'] }]
endif
if executable('cmake-language-server')
  let lspServers += [#{name: 'cmakelsp', filetype: 'cmake', path: 'cmake-language-server', initializationOptions: #{ buildDirectory:ProjectDir() } }]
endif

let lspOpts = #{autoHighlightDiags: v:true}
function! OnLspAttached()
    setlocal formatexpr=lsp#lsp#FormatExpr()
    " To jump to the symbol definition using the vim tag-commands Ctrl-]
    if exists('+tagfunc') | setlocal tagfunc=lsp#lsp#TagFunc | endif
    "Switch between source and header files.
    nmap <buffer> ,O :LspSwitchSourceHeader<CR>
    nmap <buffer> gd :LspGotoDefinition<CR>
    nmap <buffer> gs :LspDocumentSymbol<CR>
    nmap <buffer> gS :LspSymbolSearch<CR>
    nmap <buffer> gr :LspPeekReferences<CR>
    nmap <buffer> gi :LspGotoImpl<CR>
    "nmap <buffer> gt :LspGotoTypeDef<CR>
    nmap <buffer> gt :LspGotoDeclaration<CR>
    nmap <buffer> <leader>rn :LspRename<CR>
    nmap <buffer> [g :LspDiagPrev<CR>
    nmap <buffer> ]g :LspDiagNext<CR>
    nmap <buffer> K  :LspHover<CR>
endfunction

augroup lsp_install
    au!
    autocmd VimEnter * if exists('*LspAddServer') | call LspAddServer(lspServers) | endif
    autocmd VimEnter * if exists('*LspOptionsSet') | call LspOptionsSet(lspOpts) | endif
    autocmd User LspAttached call OnLspAttached()
augroup END
"}


"
" local envs
"
if filereadable(ProjectDir().'/.vimrc.local')
  exec 'source '.ProjectDir().'/.vimrc.local'
endif

let $PATH = MyVimrcDir()."/tools.libs.scripts/scripts".";".$PATH    " Got env of my scripts
if isdirectory("C:/Program Files/Git/usr/bin") | let $PATH = "C:/Program Files/Git/usr/bin".";".$PATH | endif       " for various tool at git home.
if isdirectory("C:\\Program Files (x86)\\Sun xVM VirtualBox") | let $PATH = "C:\\Program Files (x86)\\Sun xVM VirtualBox".";".$PATH | endif
let $PATH = $HOME.'\\libin\\ProgramFiles\\llvm\\clang+llvm-20.1.1-x86_64-pc-windows-msvc\\bin;'.$PATH
if exists('&pythonthreehome') | let &pythonthreehome=expand("$HOME/.conda/envs/py38") | let $PATH = &pythonthreehome.";".&pythonthreehome."/Scripts;".$PATH | endif
" http_proxy and https_proxy pointing to px (http://127.0.0.1:3128)
let $HTTP_PROXY="http://127.0.0.1:3128"
let $HTTPS_PROXY="http://127.0.0.1:3128"

"
" colo, transparent
"
colo industry
if !has('gui_running')
  hi Normal  guibg=NONE ctermbg=NONE
  hi LineNr  guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
endif


finish





--- -------------
title: vim notes
--- -------------

# Notes

vim notes.

## Tips and Snippets

1. `!start .` to open the current file location
2. `!start %` or `!start /B %` to open file with default program
3. How can I insert invisible keys into the MACRO key sequence? Press CTRL-V and then press invisible keys to input.

   ```
   CTRL-@ ==>^@==><LF>(new line?)==>(LF?CR?)==>'\n
   ```

4. switch header file and cpp file quickly

   ```Ex-Command
   :e %<.cpp
   :e %<.h
   :e %:r.h
   :e %:r.cpp
   ```

   >
   > special modifiers
   >
   >  % 当前完整的文件名
   >  %:h 文件名的头部，即文件目录.例如../path/test.c就会为../path
   >  %:t 文件名的尾部.例如../path/test.c就会为test.c
   >  %:r 无扩展名的文件名.例如../path/test就会成为test
   >  %:e 扩展名


5. to close current window `:q Or ,wq <=== <leader>wq`
6. to current dir. when current buffer is in current dir, try `CD .` else `CD %:p:h`
7. Grep the-content of the current file `Grep the-content %`
8. Expand wildcards? I want disable it! Do `Grep \%lu  ./`  instead of `Grep %lu  ./`
9. jump with CTRL-o/CTRL-i

`CTRL-o` jump to an older position, and `CTRL-i` brings you to a newer position. The mnemonic 
would be O = OUT, I = IN => Ctrl-O brings you out, Ctrl-I brings you in. If every jump likes 
going through a door, that is.

10. spell: Misspellings

  - Navigate between spelling mistakes with ]s and [s in normal mode.
  - To fix a misspelling, put your cursor over the word and type z= to see a list of suggested replacements

  > Select the First Suggestion
  > You may as well try `1z=` to select the first suggestion.

  > How to repeat fixes? By repeating "z="?
  > If you made a good fix with z=, you can repeat that replacement for all matches of the replaced word in the
  > current window:
  > `:spellrepall` or `:spellr`

  - Teach Vim Words it Doesn’t Know! Put cursor over the word and type zg.

  > To undo this action use zw, which comments out the line in the dictionary file. You can
  > also remove the entry by hand from the spell file (path/to/vim/spell/en.utf-8.add).

11. undo: goto the old text state about 1 minute before ` earlier 1m ` or ` earlier 5m `
12. go to [count] older/newer position in change list. ` g;/g, `
13. 输出当前文件所在目录下子目录（树形结构） ` r !tree %:p:h `
14. only: close all windows but the current window. and N<c-w>w goto N next window, try <c-w>w
15. Copy selections of fzf.vim window to quickfix window, try: <tab> to select targets and then press <enter>
16. In the quickfix window, Use `:cdo` to execute a command on every item in the quickfix list, `:cdo s/{pattern}/{replacement} | update` for replacing and saving.


## Question and Answer

1. How can I print git status of all repos? Traversal of the current directory:
    ```vimscript
    CD
    CD ../
    let subitems = readdir('./')
    for item in subitems
        if isdirectory(item)
            exec 'CD '.item
            Git status
            exec 'CD ../'
        endif
    endfor
    ```


## Nice Plugins

1. [fzf](https://github.com/junegunn/fzf), a general-purpose command line fuzzy finder.

 - Plug 'junegunn/fzf'
 - Plug 'junegunn/fzf.vim'

Settings for fzf:
```vimscript
if isdirectory(PackHome().'/fzf')
  let g:fzf_command_prefix = 'Fz'
  command! -bang FzDiffs call fzf#vim#files(ProjectDir(), {'sink': 'diffsplit'}, <bang>0)
  if has('popupwin')
      let g:fzf_layout={'window':{'width':0.9, 'height':0.6, 'border':'rounded', 'highlight':'Question'}}
  endif
  if executable('fzf') && !exists('g:loaded_fzf')
      let fzf_script_needed = expand($HOME).'/.fzf/plugin/fzf.vim'
      if filereadable(fzf_script_needed)
          exec 'source '.fzf_script_needed
      endif
  endif
  command! -bang Fd  call fzf#vim#files(ProjectDir(), fzf#vim#with_preview({'source':'rg --files                      --follow'}), <bang>0)
  command! -bang Fda call fzf#vim#files(ProjectDir(), fzf#vim#with_preview({'source':'rg --files --no-ignore --hidden --follow'}), <bang>0)
  command! -nargs=? -bang Rg  CD | call fzf#vim#grep('rg      --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
  command! -nargs=? -bang Rga CD | call fzf#vim#grep('rg -uuu --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
  command! -bang Fb FzBuffers
  nmap <leader><tab> <plug>(fzf-maps-n)
  xmap <leader><tab> <plug>(fzf-maps-x)
  omap <leader><tab> <plug>(fzf-maps-o)
endif
```

2. good practice with tags in vim

 - Plug 'ludovicchabant/vim-gutentags'
 - Plug 'skywind3000/gutentags_plus'

Settings:
```vimscript
if isdirectory(PackHome().'/vim-gutentags')
  let g:gutentags_project_root = g:this_project.markers
  let g:gutentags_add_default_project_roots = 0
  let g:gutentags_modules = []
  if executable('ctags')
      let g:gutentags_modules += ['ctags']
  endif
  if executable('gtags') && executable('gtags-cscope')
      let g:gutentags_modules += ['gtags_cscope']
  endif
  let g:gutentags_ctags_tagfile = '.cache/.tags'
  let g:gutentags_gtags_dbpath = '.cache/tags'
  let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
  let g:gutentags_auto_add_gtags_cscope = 0
  let g:gutentags_define_advanced_commands = 1
  let g:gutentags_plus_switch = 1
endif
```

3. AI plugin

How can I talk with AI via cmdline?

  - [vim9-ollama](https://github.com/greeschenko/vim9-ollama)
  - [vim-ai](https://github.com/madox2/vim-ai)

    > pip install openai
    >
    > I need plugin with curl instead of pys.


## Trouble shooting

1. [vimscript debugging](https://stackoverflow.com/questions/12213597/how-to-see-which-plugins-are-making-vim-slow)
  ```
  :profile start profile.log
  :profile func *
  :profile file *
  " At this point do slow actions
  :profile pause
  :noautocmd qall!
  ```
2. a lot red block _ (underscore) in my markdown document. **Turn off

 highlighting *_* for the underscore in vim** Refs.:
  - [markdownError](https://stackoverflow.com/questions/19137601/turn-off-highlighting-a-certain-pattern-in-vim)
  - [red block](https://github.com/tpope/vim-markdown/pull/40)

