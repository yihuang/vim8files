execute pathogen#infect()

" defaults for vim only.
if !has('nvim')
    syntax enable
    syntax on
    filetype off
    filetype plugin indent on
    set laststatus=2
    set fileencodings=utf-8,gbk
    set hlsearch
    set incsearch
endif

let mapleader = ","
set sw=4 ts=4 et
set splitbelow
set splitright
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>l :setlocal number!<CR>
nnoremap <Leader>o :set paste!<CR>
nnoremap j gj
nnoremap k gk
nnoremap <leader>y "*y
vnoremap <leader>y "*y
nnoremap <leader>d "*d
vnoremap <leader>d "*d
nnoremap <leader>p "*p
vnoremap <leader>p "*p
nnoremap <leader><CR> :noh\|hi Cursor guibg=red<CR>

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" colorschema
set termguicolors
colorscheme solarized8_flat

" terminal
tnoremap <C-w> <C-\><C-n><C-w>
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif
augroup term
  au!
  if has('nvim')
    au BufWinEnter,WinEnter term://* startinsert
    au BufLeave term://* stopinsert
    au TermClose * bd!|q
  else
    au BufWinEnter,WinEnter term://* exec 'normal! i'
  endif
augroup END

" languages
augroup langs
  au!
  au FileType python,lua set foldmethod=indent foldnestmax=2
  au FileType vim set foldmethod=indent foldnestmax=2 sw=2
  au BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
  au BufWrite *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&"
  " Source the vimrc file after saving it
  au BufWritePost .vimrc source $MYVIMRC
  au BufWritePost *.hs,*.hsc silent !update-tags %
  au FileType haskell set formatprg=stylish-haskell
augroup END

" ale
au FileType haskell let g:ale_linters.haskell = ['hlint']
nnoremap <silent> <leader>aj :ALENext<cr>
nnoremap <silent> <leader>ak :ALEPrevious<cr>

" bufexplorer
nnoremap <C-L> :BufExplorer<CR>

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" vim-grepper
nnoremap <leader>g :Grepper -tool git -highlight<cr>
nnoremap <leader>G :Grepper -tool rg -highlight<cr>
nnoremap gs <plug>(GrepperOperator)
xnoremap gs <plug>(GrepperOperator)

" ycm
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '/Users/yihuang/.ycm_extra_conf.py'

" haskell-vim
let g:haskell_indent_if = 2  " Align 'then' two spaces after 'if'
let g:haskell_indent_before_where = 2  " Indent 'where' block two spaces under previous body
let g:haskell_indent_case_alternative = 1  " Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_let_no_in = 0  " Only next under 'let' if there's an equals sign

" vim-hindent
let g:hindent_on_save = 0
function! HaskellFormat(which) abort
  if a:which ==# 'hindent' || a:which ==# 'both'
    :Hindent
  endif
  if a:which ==# 'stylish' || a:which ==# 'both'
    silent! exe 'undojoin'
    silent! exe 'keepjumps %!stylish-haskell'
  endif
endfunction
augroup haskellStylish
  au!
  " Just hindent
  au FileType haskell nnoremap <buffer> <leader>hi :Hindent<CR>
  " Just stylish-haskell
  au FileType haskell nnoremap <buffer> <leader>hs :call HaskellFormat('stylish')<CR>
  " First hindent, then stylish-haskell
  au FileType haskell nnoremap <buffer> <leader>hf :call HaskellFormat('both')<CR>
augroup END

" intero
let g:intero_start_immediately = 0
if has('nvim')
  let g:intero_type_on_hover = 1
  let g:intero_window_size = 80
  let g:intero_vertical_split = 1
  let g:intero_use_neomake = 0  " use ale
  set updatetime=1000  " shorter updatetime for type information.
  augroup interoMaps
    au!
    " Maps for intero. Restrict to Haskell buffers so the bindings don't collide.
  
    " Background process and window management
    au FileType haskell nnoremap <buffer> <silent> <leader>is :InteroStart<CR>
    au FileType haskell nnoremap <buffer> <silent> <leader>ik :InteroKill<CR>
  
    " Open intero/GHCi split horizontally
    au FileType haskell nnoremap <buffer> <silent> <leader>io :InteroOpen<CR>
    " Open intero/GHCi split vertically
    au FileType haskell nnoremap <buffer> <silent> <leader>iov :InteroOpen<CR><C-W>H
    au FileType haskell nnoremap <buffer> <silent> <leader>ih :InteroHide<CR>
  
    " Reloading (pick one)
    " Automatically reload on save
    " au BufWritePost *.hs InteroReload
    " Manually save and reload
    au FileType haskell nnoremap <buffer> <silent> <leader>wr :w \| :InteroReload<CR>
  
    " Load individual modules
    au FileType haskell nnoremap <buffer> <silent> <leader>il :InteroLoadCurrentModule<CR>
    au FileType haskell nnoremap <buffer> <silent> <leader>if :InteroLoadCurrentFile<CR>
  
    " Type-related information
    " Heads up! These next two differ from the rest.
    au FileType haskell map <buffer> <silent> <leader>t <Plug>InteroGenericType
    au FileType haskell map <buffer> <silent> <leader>T <Plug>InteroType
    au FileType haskell nnoremap <buffer> <silent> <leader>it :InteroTypeInsert<CR>
  
    " Navigation
    au FileType haskell nnoremap <buffer> <silent> <leader>jd :InteroGoToDef<CR>
  
    " Managing targets
    " Prompts you to enter targets (no silent):
    au FileType haskell nnoremap <buffer> <leader>ist :InteroSetTargets<SPACE>
  augroup END
end

let g:tagbar_type_haskell = {
    \ 'ctagsbin'    : 'hasktags',
    \ 'ctagsargs'   : '-x -c -o-',
    \ 'kinds'       : [
        \  'm:modules:0:1',
        \  'd:data:0:1',
        \  'd_gadt:data gadt:0:1',
        \  'nt:newtype:0:1',
        \  'c:classes:0:1',
        \  'i:instances:0:1',
        \  'cons:constructors:0:1',
        \  'c_gadt:constructor gadt:0:1',
        \  'c_a:constructor accessors:1:1',
        \  't:type names:0:1',
        \  'pt:pattern types:0:1',
        \  'pi:pattern implementations:0:1',
        \  'ft:function types:0:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'          : '.',
    \ 'kind2scope'   : {
        \ 'm'        : 'module',
        \ 'd'        : 'data',
        \ 'd_gadt'   : 'd_gadt',
        \ 'c_gadt'   : 'c_gadt',
        \ 'nt'       : 'newtype',
        \ 'cons'     : 'cons',
        \ 'c_a'      : 'accessor',
        \ 'c'        : 'class',
        \ 'i'        : 'instance'
    \ },
    \ 'scope2kind'   : {
        \ 'module'   : 'm',
        \ 'data'     : 'd',
        \ 'newtype'  : 'nt',
        \ 'cons'     : 'c_a',
        \ 'd_gadt'   : 'c_gadt',
        \ 'class'    : 'ft',
        \ 'instance' : 'ft'
    \ }
    \ }
let g:tagbar_type_rust = {
            \ 'ctagstype' : 'rust',
            \ 'kinds' : [
            \'T:types,type definitions',
            \'f:functions,function definitions',
            \'g:enum,enumeration names',
            \'s:structure names',
            \'m:modules,module names',
            \'c:consts,static constants',
            \'t:traits,traits',
            \'i:impls,trait implementations',
            \]
            \}

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.' . a:extra_filter)
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" Return to last edit position when opening files (You want this!)
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" Remember info about open buffers on close
set viminfo^=%

" cpp
let g:DoxygenToolkit_authorName="HuangYi, Boyaa Inc."
let g:DoxygenToolkit_versionString="1.0"
function! InsertGates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call InsertGates()

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" `gf` jumps to the filename under the cursor.  Point at an import statement
" and jump to it!
python3 << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" Cyclic tag navigation {{{
let g:rt_cw = ''
function! RT()
  let cw = expand('<cword>')
  try
    if cw != g:rt_cw
      execute 'tag ' . cw
      call search(cw,'c',line('.'))
    else
      try
        execute 'tnext'
      catch /.*/
        execute 'trewind'
      endtry
      call search(cw,'c',line('.'))
    endif
    let g:rt_cw = cw
  catch /.*/
    echo "no tags on " . cw
  endtry
endfunction
map <C-]> :call RT()<CR>
" }}}
