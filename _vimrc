"/*********************************************************************
"- File name: _vimrc
"- Author: libin    Version: -       Date: 2018-03-05 11:56:09
"- Description:
"  1. Copy this file to `$HOME` to initialize vim.
"
"- Others:         // 其它内容的说明
"
"- History:
"    1. Date:2019-09-22 21:56:21 Add `:PackUpdate` to load packages.
"*********************************************************************/

" Environment {
    silent function! OSX()
      return has('macunix')
    endfunction
    silent function! LINUX()
      return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
      return  (has('win32') || has('win64'))
    endfunction

    set nocompatible        " Must be first line
    " Quote shell if it contains space and is not quoted
    if &shell =~? '^[^"].* .*[^"]'
      let &shell='"' . &shell . '"'
    endif

    " Fixing: arrow-keys-type-capital-letters-instead-of-moving-the-cursor {
    if &term[:4] ==? "xterm" || &term[:5] ==? 'screen' || &term[:3] ==? 'rxvt'
      inoremap <silent> <C-[>OC <RIGHT>
    endif

    " Instead of using the $MYVIMRC, add 'g:this_vimrc' to avoid path confused.
    let g:this_vimrc = get(g:, 'this_vimrc', resolve(expand('<sfile>:p')))
    silent function! MyVimrcDir()
      return fnamemodify(g:this_vimrc, ':h')
    endfunction
" }


" General {
    filetype on                     " Detects file type
    filetype plugin on
    filetype plugin indent on

    set encoding=utf-8              " Sets the character encoding used inside Vim.
    scriptencoding utf-8            " If you set the 'encoding' option :scriptencoding must be placed after that.
    set fileencoding=utf-8          " Sets the character encoding for the file of this buffer.
    " When editing an existing file, Vim tries to use the first mentioned character encoding in the :fileencodings
    set fileencodings=ucs-bom,utf-8,gbk,gb2312,gb18030,big5,cp936,latin1

    syntax enable                   " Syntax highlighting

    set shortmess+=filmnrxoOtT      " 去掉欢迎界面 set shortmess=atI
    set autoindent                  " Indent at the same level of the previous line
    set autoread                    " 当文件在外部被修改，自动更新该文件
    set backspace=indent,eol,start  " Backspace for dummies
    set expandtab                   " Tabs are spaces, not tabs
    set hidden                      " Allow buffer switching without saving
    set history=1000                " Store a ton of history (default is 20)
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set incsearch                   " `set noincsearch` " 在输入要搜索的文字时，取消实时匹配
    set iskeyword-=#                " '#' is an end of word designator
    set iskeyword-=-                " '-' is an end of word designator
    set iskeyword-=.                " '.' is an end of word designator
    set matchpairs+=<:>             " Match, to be used with %
    set mouse=a                     " Enable mouse usage
    set mousehide                   " Hide the mouse cursor while typing
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set nowrap                      " Do not wrap long lines
    set number                      " Line numbers on
    "set path+=**                    " 检索file_in_path时递归查找子目录, 递归就会拖慢
    set relativenumber              " Line relative numbers on
    "set spell                       " Spell checking on
    set shiftwidth=2                " Use indents of 2 spaces
    set showmatch                   " Show matching brackets/parenthesis
    set smartcase                   " Case sensitive when uc present
    set smartindent                 " Enable smart indent
    set smarttab                    " 指定按一次backspace就删除shiftwidth宽度
    set softtabstop=2               " Let backspace delete indent
    set tabpagemax=15               " Only show 15 tabs
    set tabstop=2                   " An indentation every 2 columns
    "set vb t_vb=                    " 关闭提示音
    set viewoptions=folds,options,cursor,unix,slash    " Better Unix / Windows compatibility
    set virtualedit=onemore         " Allow for cursor beyond last character
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.

    set nofoldenable                " 禁用折叠 `set foldenable` " 启用折叠
    set foldmethod=indent           " indent 折叠方式 `set foldmethod=marker` " marker 折叠方式
    " 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
    if has('clipboard')
      set clipboard=unnamed
      if has('unnamedplus') || has('nvim')  " When possible use + register for copy-paste
        set clipboard+=unnamedplus
      endif
    endif
    if exists('&pastetoggle')       " pastetoggle (sane indentation on pastes)
      set pastetoggle=<F12>
    endif

    " 非可见字符不显示, `set list`可按预定字符(listchars指定)替代显示非可见字符
    set list
    " 设置非可见字符的显示时的可见字符替代方案
    set listchars=tab:›\ ,trail:•,extends:>,precedes:<,nbsp:.
    if &encoding !=? 'utf-8'
      let warning_msg = printf("The encoding option is not utf-8 (it's %s), ".
                              \"make sure characters of listchars (%s) valid please.",
                              \&encoding, &listchars)
      echohl WarningMsg | echomsg warning_msg | echohl NONE
    endif

    " Jumping with tags:
    " A tag is an identifier that appears in a "tags" file.  It is a sort of label
    " that can be jumped to. The "tags" file should be generated by a tool like
    " "ctags -R -c++-kinds=+px -fields=+iaS -extra=+q" before the ":tag" commands
    " can be used. With the ":tag" command the cursor will be positioned on the tag.
    " With the CTRL-] command, the keyword on which the cursor is standing is used
    " as the tag.  If the cursor is not on a keyword, the first keyword to the right
    " of the cursor is used. For more infomation, please ":h tags"
    "
    " The tool of "gtags" (or "cscope") is a tagging system which works the same way
    " across diverse environments. Plugins which intergrated the tagging system can be
    " easy to use.
    "
    " 以下设置索引文件名为".tags",以小数点开头更便于识别。后面的分号不要去掉!!
    " 加`;`表示若当前编辑的文件所在目录中不存在".tags"，则在其父目录中查找".tags"直至根目录。
    set tags=./.tags;
    " 缺省索引文件文件 "tags", 放最低优先级
    set tags+=tags

    " Executing grep/vimgrep with ripgrep
    if executable('rg')
      set grepprg=rg\ --vimgrep\ --no-heading\ --follow\ --smart-case
    endif

    " Enable persistent_undo
    if has('persistent_undo')
      set undofile                " So is persistent undo ...
      set undolevels=1000         " Maximum number of changes that can be undone
      set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
      " Put undofile in the unified directory
      let uDir = MyVimrcDir().'/.vim/undo'
      if !isdirectory(uDir) && exists('*mkdir')
        call mkdir(uDir, 'p', 0o700)
      endif
      let &undodir = printf('%s,%s', uDir, &undodir)
    endif

    "let g:opt_backup_enable = 1           " To enable backup, uncomment this line.
    if exists('g:opt_backup_enable')
      set backup                  " Backups are nice ...
    else
      set nobackup                " 设置无备份文件
      set writebackup             " 保存文件前建立备份，保存成功后删除该备份
      set noswapfile              " 设置无临时文件
    endif
" }


" UI Settings {
    " dark background, allow to toggle between dark and light
    set background=dark
    nnoremap <silent> <leader>bg <Cmd>if &bg ==? "dark"<Bar>set bg=light<Bar>else<Bar>set bg=dark<Bar>endif<CR>
    set winminheight=0              " Windows can be 0 line high
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set fillchars=vert:\ ,fold:-    " Sets characters to fill the statuslines and vertical separators.
    set t_Co=256                    " 8-bit color (256 colors) to make xterm/win32 vim shine
    set termguicolors               " Uses guibg/fg attributes in the terminal, thus using True color (24-bit color).
    set cursorline                  " Highlight current line
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set noshowmode                  " Don't display the current mode

    set cmdheight=2                 " Set command line height as 2，default 1
    if has('cmdline_info')
      set ruler                   " Show the ruler
      set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)     " A ruler on steroids
      set showcmd                 " Show partial commands in status line and selected characters/lines in visual mode
    endif

    if has('statusline')
      set laststatus=2                         " Switch status line on
      let g:theModes={'n':'Normal', 'no':'Normal·Operator Pending', 'v':'Visual', 'V':'V·Line', '^V':'V·Block', 's':'Select', 'S':'S·Line', '^S':'S·Block', 'i':'Insert',
            \ 'R':'Replace', 'Rv':'V·Replace', 'c':'Command', 'cv':'Vim Ex', 'ce':'Ex', 'r':'Prompt', 'rm':'More', 'r?':'Confirm', '!':'Shell', 't':'Terminal'}
      silent function! CurrentMode()
        return has_key(g:theModes, mode()) ? toupper(g:theModes[mode()]) : mode()
      endfunction
      silent function! FencStr()
        let fencStr = empty(&fenc) ? &enc : &fenc
        let bombStr = (exists('+bomb') && &bomb) ? ' with BOM' : ''
        return fencStr.bombStr
      endfunction
      silent function! BuffersListed()
        return len(getbufinfo({'buflisted':1}))
      endfunction
      silent function! GitBranch()
        return exists('*FugitiveHead')? FugitiveHead() : ''
      endfunction

      " Broken down into includeable segments
      set statusline=%<%#WildMenu#\ %{&paste?'PASTE':CurrentMode()}\ %*
      set statusline+=%<%#Pmenu#%{GitBranch()!=#''?'\ '.GitBranch().'\ \|':''}%*
      set statusline+=%<%#Pmenu#\ %f\ \|\ %{exists('b:stl_title')?b:stl_title.'\ ':''}%w%m%r[b%n/%{BuffersListed()}]\ %*
      set statusline+=%<%#SignColumn#\ %{ReadableSize(wordcount().bytes)}\ %*
      set statusline+=%<%#SignColumn#\ %=    " Right side
      set statusline+=%<%#SignColumn#\ %{FencStr()},%{&ff}/%{&ft!=#''?&ft:'no\ ft'}\ %*
      set statusline+=%<%#Visual#\ %p%%\ %*                   " Right aligned file navigation info.
      set statusline+=%<%#Visual#\ %(%3l:%-2c\ %)%*
      set statusline+=%<%#StatusLineTermNC#\ %{winnr()}\ %*   " <C-W>w goto next window, N<C-W>w goto (winnr:N) window.
    endif

    if has('gui_running')
      winpos 100 10                     " 指定窗口出现的位置，坐标原点在屏幕左上角
      set lines=40 | set columns=120    " 指定窗口大小，lines为高度，columns为宽度
      if LINUX()   | set guifont=Inconsolata\ 12 | endif
      if OSX()     | set guifont=Inconsolata:h12 | endif
      if WINDOWS() | set guifont=Consolas:h10,Inconsolata:h12 | endif
      " 显示/隐藏菜单栏、工具栏、滚动条，可用 <C-F11> 切换
      set guioptions-=m | set guioptions-=T | set guioptions-=r | set guioptions-=L
      nnoremap <silent> <C-F11> :if &guioptions =~# 'm' <Bar>
            \  set guioptions-=m <Bar> set guioptions-=T <Bar> set guioptions-=r <Bar> set guioptions-=L <Bar>
            \else <Bar>
            \  set guioptions+=m <Bar> set guioptions+=T <Bar> set guioptions+=r <Bar> set guioptions+=L <Bar>
            \endif<CR>
    endif
" }


" Functional {
    " Twice the Result with Half the Effort {
        function! StripTrailingWhitespaceTrimming(begin, end)
          " Preparation: save last search/cursor position.
          let _s=@/
          let l = line(".")
          let c = col(".")
          " do the business:  %s/\s\+$//e
          silent! exec printf("%d,%ds/\\s\\+$//e", a:begin, a:end)
          " clean up: restore previous search history, and cursor position
          let @/=_s
          call cursor(l, c)
        endfunction
        command! -range=% -nargs=0 Trim call StripTrailingWhitespaceTrimming(<line1>, <line2>)

        function! ClangFormat(begin, end)
          let pys = fnamemodify(exepath('clang-format'), ':p:h').'/../share/clang/clang-format.py'
          if filereadable(pys)
            let l:lines = a:begin.':'.a:end
            if has('python') | exec 'pyf '.pys | elseif has('python3') | exec 'py3f '.pys | endif
          endif
        endfunction
        command! -range=% -nargs=0 Cfmt call ClangFormat(<line1>, <line2>)

        function! ReadableSize(size)               " ---0------1-----2-----3--
          let p = 0 | let l = a:size | let unit = ['Bytes', 'KB', 'MB', 'GB']
          while l > 1024 | let l = l / 1024.0 | let p = p + 1 | endwhile
          let readableSize = printf('%d %s', a:size, unit[0])
          if p > 0 | let readableSize = printf('%d %s, %.2f %s', a:size, unit[0], l, unit[p]) | endif
          return readableSize
        endfunction
        command! -bar -nargs=? -complete=file Size echo ReadableSize(getfsize(@%))

        " Sync files between local source and destination (ssh config is for remote).
        function! SyncFiles(src, dest)
          if a:src == '' | echohl ErrorMsg | echomsg printf('source cannot be empty.') | echohl NONE | endif
          let host = '' | let source = a:src | let destination = a:dest | let tmpfmt = a:src.' %s'
          if destination == ''
            let choices='' | let i = 1 | let h = '' | let hosts=['NA']
            echo 'Hosts:' | echo printf(' [%d] local', i) | call add(hosts, h) | let i+=1
            let sshconfig = expand('$HOME/.ssh/config')
            if filereadable(sshconfig)
              let items = filter(readfile(sshconfig), 'v:val =~ "^Host\\s\\+"')
              for h in items
                let h = substitute(h, '^\s*Host\s\+\(.*\)\s*', '\1', 'g')
                echo printf(' [%d] %s', i, h) | call add(hosts, h.':') | let i+=1
              endfor
            endif
            let host = get(hosts, input("To:"), 'NA') | let tmpfmt = source.' '.host.'%s'
            if host ==# 'NA' | let host = get(hosts, input("From:"), 'NA') | let tmpfmt = host.'%s '.source | endif
            let destination = input("destination:")
          endif
          if host != 'NA' && destination != ''
            if executable('rsync')
              let cmd = printf('rsync -zahcvv --stats '.tmpfmt, destination)
              let fltconfig = executable('rg')? get(glob('`rg --files | rg rsync_filter.txt`', 0, 1), 0, '')
                    \: findfile('rsync_filter.txt', '**/*')  " Downward search
              if fltconfig != '' | let cmd = cmd.' --filter="merge '.fltconfig.'"' | endif
              call JobStart('SyncFiles[rsync]'.destination, cmd)
            elseif executable('scp')
              call JobStart('SyncFiles[scp]'.destination, printf("scp -Cprv ".tmpfmt, destination))
            else
              echohl ErrorMsg | echomsg printf('No executable sync tool.') | echohl NONE
            endif
          endif
        endfunction
        command! -bar -nargs=+ -complete=file Sync call SyncFiles(<f-args>)
        command! -bar -nargs=+ -complete=file SyncI call SyncFiles(<q-args>, '')

        function! Redirect(...)
          let cmd = join(a:000, ' ')
          let temp_reg = @"
          redir @"
          silent! execute cmd
          redir END
          let output = copy(@")
          let @" = temp_reg
          if empty(output)
            echo "---========== no output ==========---"
          else
            new
            syntax clear
            setlocal modifiable bt=nofile bh=wipe nobl nolist noswf nowrap nospell nu nornu
            nnoremap <silent><buffer> q :q!<CR>
            put! = output
            call append('$', "---")
            call append('$', "Press 'q' to quit this buffer.")
          endif
        endfunction
        command! -nargs=+ -complete=command Red call Redirect(<f-args>)

        " Toggle Quickfix window of the current tab page
        function! ToggleQuickfix()
          for win in range(1, winnr('$'))
            let wininfo = getwininfo(win_getid(win))
            if !empty(wininfo) && wininfo[0].quickfix && !wininfo[0].loclist
              cclose
              return
            endif
          endfor
          copen
        endfunction
        nnoremap <silent> Q :call ToggleQuickfix()<CR>

        " Wipe out the hidden or unloaded (after `:bdelete`) buffers
        function! Bwipeout(all) abort
          let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded || v.hidden})
          if !empty(l:buffers)
            execute a:all? 'bwipeout!':'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
          endif
        endfunction
        command! -bar -bang Bw call Bwipeout(<bang>0)
    " }

    " For the Projects {
        silent function! ProjectDir(seek=0, path='')
          let g:this_project = get(g:, 'this_project',
                \{'markers': ['.git', '.svn', '.vs', '.vscode', '.editorconfig'], 'path':'' })
          if !empty(a:path)
            let g:this_project.path = trim(fnamemodify(expand(a:path), ':p'))
          endif
          if a:seek || empty(g:this_project.path)
            let name = trim(fnamemodify(bufname(), ':p'))
            let g:this_project.path = trim(fnamemodify(name, ':h'))
            let finding = ''
            for marker in g:this_project.markers     " iterate all markers
              " search as a file
              let x = findfile(marker, name . '/;')   " Upward search
              let x = (x == '')? '' : fnamemodify(x, ':p:h')
              " search as a directory
              let y = finddir(marker, name . '/;')
              let y = (y == '')? '' : fnamemodify(y, ':p:h:h')
              " which one is the nearest directory ?
              let z = (strchars(x) > strchars(y))? x : y
              " keep the nearest one in finding
              let finding = (strchars(z) > strchars(finding))? z : finding
            endfor
            if finding != ''
              let g:this_project.path = trim(fnamemodify(finding, ':p'))
            endif
          endif
          return g:this_project.path
        endfunction

        " Return the project root directory name as the project name.
        silent function! ProjectName()
          return trim(fnamemodify(ProjectDir(), ':h:t'))
        endfunction
        command! -bar -bang -nargs=? -complete=dir CD  exec 'cd '.ProjectDir(<bang>0, <q-args>) | echo ProjectDir()
    " }

    " Wrapper of the CLIs job control {
        silent function! JobCallback(jid, cwd, cb, event, channel, data, streamname='')
          if !empty(a:cb) && type(a:cb) ==? type(function("tr"))
            call a:cb(a:jid, a:cwd, a:event, a:channel, a:data)
          else
            let l:job = a:channel | if exists('*ch_getjob') | let l:job = ch_getjob(a:channel) | endif
            let l:buf = bufnr(a:jid.'$') | let l:wid = bufwinid(l:buf)
            if l:wid ==? -1
              silent execute 'lcd '.a:cwd | silent execute 'new '.a:jid | syntax clear
              setlocal modifiable bt=nofile bh=wipe nobl nolist noswf nowrap nospell nu nornu
              let l:buf = bufnr() | let l:wid = bufwinid(l:buf) | let b:ss = 0   " Hold job and scrolling switch
              nnoremap <silent><buffer><leader>ss :let b:ss = (b:ss != 0)? 0 : 1<CR>
              if exists('*job_stop') | nnoremap <silent><buffer><leader>k :call job_stop(b:job, 'kill')<CR> | endif
              if exists('*jobstop') | nnoremap <silent><buffer><leader>k :call jobstop(b:job)<CR> | endif
            endif
            if !empty(a:data) | call setbufvar(l:buf, '&modifiable', 1) | call setbufline(l:buf, line('$')+1, a:data) | endif
            call setbufvar(l:buf, 'job', l:job) | call setbufvar(l:buf, '&modified', 0) | call setbufvar(l:buf, '&modifiable', 0)
            if getbufvar(l:buf, 'ss') != 0 | call win_gotoid(l:wid) | call cursor('$', 0) | endif
            if a:event ==? 'exit'
              let l:stl_title = getbufvar(l:buf, 'stl_title') | call setbufvar(l:buf, 'stl_title', '*'.l:stl_title)
            endif
          endif
        endfunction

        " Encapsulate the job_start function. Usage: JobStart(jid, cmd, [cwd], [callback])
        silent function! JobStart(jid, cmd, cwd=getcwd(), callback={})
          let jid = substitute(strpart(a:jid, 0, 64), '\W', '-', 'g')
          let cwd = trim(fnamemodify(expand(a:cwd), ':p'))
          let cmd = printf('%s %s "%s"', &shell, &shellcmdflag, trim(a:cmd))
          if exists('*job_start') && exists('*job_status')
            let job = job_start(cmd, { 'out_cb':  function('JobCallback', [jid, cwd, a:callback, 'stdout']),
                  \                    'err_cb':  function('JobCallback', [jid, cwd, a:callback, 'stderr']),
                  \                    'exit_cb': function('JobCallback', [jid, cwd, a:callback, 'exit']),
                  \                    'mode': 'nl',
                  \                    'cwd': cwd })
            if job_status(job) !=? 'run'
              echohl ErrorMsg | echomsg 'Starting:' cmd 'failed, jobinfo:' job_info(job) | echohl NONE
            else
              echomsg 'Starting:' cmd 'succeeded, jobinfo:' job
              call JobCallback(jid, cwd, a:callback, 'init', job_getchannel(job), '')
            endif
          elseif exists('*jobstart')
            let job = jobstart(a:cmd, { 'on_stdout': function('JobCallback', [jid, cwd, a:callback, 'stdout']),
                  \                     'on_stderr': function('JobCallback', [jid, cwd, a:callback, 'stderr']),
                  \                     'on_exit':   function('JobCallback', [jid, cwd, a:callback, 'exit']),
                  \                     'cwd': cwd })
            if job <= 0
              echohl ErrorMsg | echomsg 'Starting:' cmd 'failed, errorcode:' job | echohl NONE
            else
              echomsg 'Starting:' cmd 'succeeded.'
              call JobCallback(jid, cwd, a:callback, 'init', job, '')
            endif
          else
              echohl ErrorMsg | echomsg 'Job API not available, VIM:' v:progpath | echohl NONE
          endif
        endfunction
        command! -nargs=+ -complete=file_in_path Start call JobStart(<q-args>, <q-args>)

        " Use QuickFix instead of shell output window
        silent function! SetQfList(qfopts, jid, cwd, event, channel, data) 
          let l:qfbufnr = getqflist({'qfbufnr':0}).qfbufnr | let l:job = getbufvar(l:qfbufnr, 'job')
          if a:event ==? 'init'
            if type(l:job) ==? type({}) && has_key(l:job, a:jid)
              cclose | copen | silent exec 'lcd '.a:cwd | call setqflist([], 'u', {'id': l:job[a:jid].id, 'title': a:jid}->extend(a:qfopts))
              silent exec getqflist({'id': l:job[a:jid].id, 'nr':0}).nr.'chistory'
            else
              copen | silent exec 'lcd '.a:cwd | call setqflist([], ' ', {'nr':'$', 'title': a:jid, 'lines':[]}->extend(a:qfopts))
              if exists('*job_stop') | nnoremap <silent><buffer><leader>k :call job_stop(ch_getjob(b:job[getqflist({'id':0}).id].chn), 'kill')<CR> | endif
              if exists('*jobstop') | nnoremap <silent><buffer><leader>k :call jobstop(b:job[getqflist({'id':0}).id].chn)<CR> | endif
            endif
            let l:qflstid = getqflist({'id':0}).id | let l:m = {l:qflstid : {'chn': a:channel}, a:jid : {'id': l:qflstid}}
            call setbufvar(getqflist({'qfbufnr':0}).qfbufnr, 'job', (type(l:job) != type({})? l:m : extend(l:job, l:m)))
          else
            if type(l:job) ==? type({}) && has_key(l:job, a:jid)
              if a:event ==? 'exit'
                cclose | call setqflist([], 'u', {'id': l:job[a:jid].id, 'title': '*'.a:jid}) | copen
              else
                let lines = a:data | if type(a:data) != type([]) | let lines = [a:data] | endif
                call setqflist([], 'a', {'id': l:job[a:jid].id, 'lines': lines}->extend(a:qfopts))
              endif
            endif
          endif
        endfunction
        command! -nargs=+ -complete=file_in_path Quick call JobStart(<q-args>, <q-args>, getcwd(), function('SetQfList', [{}]))
    " }
" }


" Key Mappings / Commands / Autocmds {
    inoremap jk <ESC>
    nnoremap <BS> :noh<CR>
    " 注：在常规模式下，<leader>cM就是按\键再按c键再按M键，无须同时，允许按键间隔一秒。
    let g:mapleader = ','    " default leader: \
    " 常规模式下，输入<leader>cM可清除行尾^M符号
    nnoremap <leader>cM :%s/\r$//g<CR>:noh<CR>
    " 重读/在新的分屏中打开我的 ~/.vimrc 文件 :source $MYVIMRC<CR> :vsplit $MYVIMRC<CR>
    nnoremap <leader>ve :exec 'vsplit '.g:this_vimrc<CR>
    nnoremap <leader>sv :exec 'source '.g:this_vimrc<CR>
    nnoremap <leader>w <C-W>
    nnoremap <leader>q <Cmd>bdelete<CR>
    nnoremap <leader>p <Cmd>bprevious<CR>
    nnoremap <leader>n <Cmd>bnext<CR>
    nnoremap <leader>o <Cmd>b#<CR>
    nnoremap <leader>e <Cmd>edit <cfile><CR>
    nnoremap <leader>g <Cmd>Grep! <cexpr> .<CR>
    nnoremap <leader>f <Cmd>Find! <cexpr><CR>
    nnoremap <leader>G :Grep!<space><space>
    nnoremap <leader>F :Find!<space><space>
    nnoremap <leader>W :!start<space><space>
    nnoremap <leader>S :Start<space><space>
    nnoremap <leader>Q :Quick<space><space>
    " Open current buffer in new tab page
    nnoremap <Tab><Tab> <Cmd>tab split<CR>
    nnoremap <Tab>n <Cmd>tabnext<CR>
    nnoremap <Tab>p <Cmd>tabprevious<CR>
    if !has('nvim') && has('terminal')
      nnoremap <leader>` <Cmd>terminal ++curwin<CR> | set termwinkey=<C-L> | tnoremap <C-L>p <Cmd>tabprevious<CR>
    else
      nnoremap <leader>` <Cmd>terminal<CR><Cmd>startinsert<CR> | tnoremap <C-L> <C-\> | tnoremap <C-L>N <C-\><C-N>
    endif
    " Insert current time at the cursor position
    inoremap <silent> <C-D> <C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>
    inoremap <Tab>l <C-X><C-L>|inoremap <Tab>n <C-X><C-N>|inoremap <Tab>p <C-X><C-P>|inoremap <Tab>k <C-X><C-K>
    inoremap <Tab>t <C-X><C-T>|inoremap <Tab>i <C-X><C-I>|inoremap <Tab>] <C-X><C-]>|inoremap <Tab>f <C-X><C-F>
    inoremap <Tab>d <C-X><C-D>|inoremap <Tab>v <C-X><C-V>|inoremap <Tab>u <C-X><C-U>|inoremap <Tab>o <C-X><C-O>
    inoremap <Tab>s <C-X>s
    nnoremap <silent> M <Cmd>Red message<CR>
    nnoremap <silent> [q <Cmd>cprev<CR> | nnoremap <silent> ]q <Cmd>cnext<CR>
    nnoremap <silent> [w <Cmd>lprev<CR> | nnoremap <silent> ]w <Cmd>lnext<CR>
    nnoremap <expr> <C-H> '<C-W><'.v:count1 | nnoremap <expr> <C-L> '<C-W>>'.v:count1
    nnoremap <expr> <C-J> '<C-W>+'.v:count1 | nnoremap <expr> <C-K> '<C-W>-'.v:count1
    " Create stmt to get the key sequence which is a MACRO in the target register (example w).
    " After recording a macro with w, typing "w<leader>mm can create stmt to get this macro.
    " In future, you can get this macro by executing this stmt, and execute macro with @w
    nnoremap <leader>mm :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><LEFT>
    " Run the selected vimscript lines
    command! -range Run let lines = getline(<line1>,<line2>) | call execute(lines,'') | echo len(lines).' lines executed.'
    " Run the CLI at the current line or CLIs in the selected lines with shell
    nnoremap <space><enter> ""yy:bo new<CR>:setl bt=nofile bh=wipe nobl nolist noswf nowrap nospell nu nornu<CR>""P<CR>:exec '%!'.&shell<CR>
    vnoremap <space><enter> "vy:bo new<CR>:setl bt=nofile bh=wipe nobl nolist noswf nowrap nospell nu nornu<CR>"vP<CR>:exec 'lcd '.ProjectDir()<CR>:exec '%!'.&shell<CR>
    command! -range Puml exec 'normal! gv"vy' | bo new | setl bt=nofile bh=wipe nobl nolist noswf nowrap nospell nu nornu| exec 'normal! "vP' |
          \ exec '%!java -jar '.MyVimrcDir().'/../tools.libs.scripts/tools/plantuml.jar -v -tsvg -pipe > #<-diagram.svg'
    let &spf = MyVimrcDir().'/../tools.libs.scripts/scripts/spell.'.&encoding.'.add' | nnoremap <leader>vz :exec 'vsplit' &spf<CR>
    nnoremap <leader>vs :exec 'vsplit' MyVimrcDir().'/../tools.libs.scripts/snippets.md'<CR> " 选中沉淀，Run或<space><enter>
    " Review comments in the project directory
    nnoremap <leader>vc :execute 'vsplit' ProjectDir().'/review.md'<CR>
    nnoremap <leader>lc :let @*=expand('%:p').' :'.line('.').':'.col('.')<CR>:echo '-=Cursor Postion Copied=-'<CR>
    nnoremap <leader>ll :let dbk =getcwd()<CR>:silent! exec 'lcd' ProjectDir()<CR>
          \ :let @*=expand('%:p:.').' ('.line('.').')'<CR>:silent! exec 'lcd' dbk<CR>:echo '-=Relative Postion Copied=-'<CR>
    command! -range=% -nargs=* Gitlog exec 'Start git --no-pager log -L '.<line1>.','.<line2>.':'.expand('%').' '.<q-args>
    command! -range=% -nargs=* Gitblame exec 'Start git --no-pager blame -L '.<line1>.','.<line2>.' -- '.expand('%').' '.<q-args>
    command! -nargs=* -complete=dir Rg exec 'Start rg --vimgrep --no-heading --follow  --smart-case ' <q-args>
    command! -nargs=* -complete=dir Rga exec 'Start rg -uuu --vimgrep --no-heading --follow --smart-case ' <q-args>
    command! -bang -nargs=* -complete=dir Grep exec 'Quick rg '.(<bang>0?'':'--max-depth=4').' --vimgrep --no-heading --follow  --smart-case ' <q-args>
    function! RgFilesCmd(cmdopt_rgfiles, cmdopt_pattern='', cmdopt_path='', ...)
      let rgpattern = a:cmdopt_pattern!=''? ' | rg --no-heading --smart-case '.a:cmdopt_pattern : ''
      return 'rg --files '.a:cmdopt_rgfiles.' '.join(a:000, ' ').' '.a:cmdopt_path.' '.rgpattern
    endfunction
    command! -nargs=* -complete=dir Fd exec 'Start '.RgFilesCmd('--sort path', <f-args>)
    command! -nargs=* -complete=dir Fda exec 'Start '.RgFilesCmd('--no-ignore --hidden --sort path', <f-args>)
    command! -bang -nargs=* -complete=dir Find let cli = RgFilesCmd((<bang>0?'':'--max-depth=4').' --sort path', <f-args>)
          \| call JobStart(cli, cli, getcwd(), function('SetQfList', [{'efm':'%f'}]))

    " Define autocommands of this vimrc
    augroup VimRcAUs
      autocmd!
      " Seek project directory when vim entered.
      autocmd VimEnter * if &buftype !=? 'terminal' && bufname("") !~ "^\[A-Za-z0-9\]*://" | call ProjectDir() | endif
      " Sets cwd to the file directory when buffer entered.
      autocmd BufEnter * if &buftype ==? "" && bufname("") !~ "^\[A-Za-z0-9\]*://" | try | lcd %:p:h | catch /^Vim\%((\a\+)\)\=:E/ | endtry | endif
      " Restore cursor to file position in previous editing session.
      autocmd BufWinEnter * if line("'\"") <= line("$") | silent! normal! g`" | endif
      " Toggle line width 启用每行超过某一字符总数后给予字符变化提示（字体变蓝加下划线）
      autocmd BufWinEnter * if exists('w:line_width') && w:line_width | let w:m2 = matchadd('Underlined', printf('\%%>%dv.\+', 120), -1)
            \| elseif exists('w:m2') && w:m2 != -1 | call matchdelete(w:m2) | let w:m2 = -1 | endif
      nnoremap <silent><leader>lw :let w:line_width = !(exists('w:line_width') && w:line_width)<CR>:doautocmd VimRcAUs BufWinEnter<CR>
      autocmd GUIEnter * simalt ~x    " 窗口启动时自动最大化
      " Instead of reverting the cursor to the last position in the buffer, we set it to the first line when editing a git commit message
      autocmd FileType gitcommit autocmd BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
      " For reading content of quickfix again (<leader>u), setting errorformat tell vim how to read its own quickfix list
      autocmd FileType qf setl nobl nolist nowrap nospell nu nornu
            \| setl errorformat=%f\|%l\ col\ %c\|%m
            \| nnoremap <buffer> K :cprev<CR>zz<C-W>p | nnoremap <buffer> J :cnext<CR>zz<C-W>p
            \| nnoremap <buffer> <leader>m :if &modifiable<Bar>setl noma nomod<Bar>else<Bar>setl ma<Bar>endif<CR>
            \| nnoremap <buffer> <leader>u :cgetbuffer<CR>:cclose<CR>:copen<CR>
            \| nnoremap <buffer> <leader>r :cdo s/// \| update<C-Left><C-Left><Left><Left><Left>
            \| nnoremap <buffer> <leader>q <Cmd>call setqflist([], 'f')<CR><Cmd>bdelete<CR>
            \| nnoremap <buffer><silent><leader>n <Cmd>cnewer<CR> | nnoremap <buffer><silent><leader>p <Cmd>colder<CR>
            \| if exists('w:quickfix_title') | let b:stl_title=w:quickfix_title | endif
      if exists('#TerminalOpen')
        autocmd TerminalOpen * setl nolist nowrap nospell nu nornu
      endif
      if exists('#TermOpen')
        autocmd TermOpen * setl nolist nowrap nospell nonu nornu
      endif
      if has('statusline')
        autocmd BufWinEnter,OptionSet * if !buflisted(bufnr('%'))
              \| setl stl=%<%#WildMenu#\ %{&paste?'PASTE':CurrentMode()}\ %*
              \| setl stl+=%<%#Pmenu#\ %t%{exists('b:stl_title')?'\ '.b:stl_title:''}\ %*
              \| setl stl+=%<%#SignColumn#\ %{ReadableSize(wordcount().bytes)}\ %*
              \| setl stl+=%<%#SignColumn#\ %=%{FencStr()},%{&ff}/%{&ft!=#''?&ft:'no\ ft'}\ %*
              \| setl stl+=%<%#Visual#\ %p%%\ %(%3l/%-2L\ %)%<%#StatusLineTermNC#\ %{winnr()}\ %*
              \| endif
      endif
      autocmd ColorScheme * hi clear CursorLineSign | hi clear SignColumn  " For a Clear Sign Column
    augroup END
" }


" For Plugins {
    " Return the packages directory
    silent function! PackHome()
      return MyVimrcDir().'/.vim/plugged'
    endfunction
    " Set packpath option.
    if has("packages")
      if !isdirectory(PackHome()) && exists('*mkdir')
        call mkdir(PackHome(), 'p')
      endif
      let &packpath = printf('%s,%s', &packpath, PackHome())
    endif
    " Load all plugins
    silent function! VimPlugUpdate()
      if !filereadable(PackHome().'/plug.vim')
        let l:uri = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        call JobStart('downloading vim-plug', 'curl -vLs -o '.PackHome().'/plug.vim '.l:uri, PackHome())
      else
        exec 'source '.PackHome().'/plug.vim'
        nnoremap <leader>vp :execute 'vsplit' MyVimrcDir().'/.vim-plugins.vim'<CR>
        if filereadable(MyVimrcDir().'/.vim-plugins.vim')  " Load .vim-plugins.vim based on `vim-plug`
          exec 'source '.MyVimrcDir().'/.vim-plugins.vim'
        else
          let l:tmplst = [ '" Specify a directory for plugins',
                      \ 'call plug#begin(PackHome())',
                      \ '"',
                      \ '" List the plugins with Plug commands',
                      \ 'Plug ''tpope/vim-fugitive''',
                      \ 'call plug#end()',
                      \ '" INITIALIZATION OF PLUGINs']
          if writefile(l:tmplst, MyVimrcDir().'/.vim-plugins.vim', 'b') !=? 0
            echohl WarningMsg | echomsg 'Write file (.vim-plugins.vim) failed.' | echohl NONE
            nunmap <leader>vp
          endif
        endif
      endif
    endfunction
    command! -nargs=0 -bar PackUpdate call VimPlugUpdate()
" }

" PackUpdate: loading plugins
PackUpdate
