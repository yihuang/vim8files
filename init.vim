filetype off
execute pathogen#infect()

" defaults for vim only.
filetype plugin indent on
if !has('nvim')
    syntax enable
    syntax on
    set laststatus=2
    set fileencodings=utf-8,gbk
    set hlsearch
    set incsearch
endif

let mapleader = ","
set sw=4 ts=4 et
set splitbelow
set splitright
nnoremap <leader><CR> :noh\|hi Cursor guibg=red<CR>
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>l :setlocal number!<CR>
nnoremap <Leader>o :set paste!<CR>
nnoremap j gj
nnoremap k gk
" clipboard
nnoremap <leader>y "*y
vnoremap <leader>y "*y
nnoremap <leader>d "*d
vnoremap <leader>d "*d
nnoremap <leader>p "*p
vnoremap <leader>p "*p

" swap :tag and :tselect
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" colorschema
set termguicolors
colorscheme solarized8_flat

" terminal
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
  " Source the vimrc file after saving it
  au BufWritePost .vimrc source $MYVIMRC
  au BufWritePost *.hs,*.hsc silent !update-tags %
  au FileType haskell set formatprg=stylish-haskell
augroup END

" ale
au FileType haskell let g:ale_linters.haskell = ['stack-build']
nnoremap <silent> <leader>aj :ALENext<cr>
nnoremap <silent> <leader>ak :ALEPrevious<cr>
let g:ale_linters = {'go': ['gometalinter']}
let g:go_fmt_fail_silently = 1  " https://github.com/w0rp/ale/issues/609
let g:ale_echo_msg_format = '%linter% says %s'
let g:go_fmt_command = "goimports"

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
      \ 'haskell': ['hie-wrapper'],
      \ }
" \ 'python': ['pyls']

let g:LanguageClient_rootMarkers = ['.git']
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <Leader>lb :call LanguageClient#textDocument_references()<CR>
map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

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


" cscope
nmap <leader><Space>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader><Space>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader><Space>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader><Space>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader><Space>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader><Space>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader><Space>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader><Space>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <leader><Space>a :cs find a <C-R>=expand("<cword>")<CR><CR>

" racer (rust)
au FileType rust nmap <C-]> <Plug>(rust-def)
au FileType rust nmap gd <Plug>(rust-doc)

" pgsql
let g:sql_type_default = 'pgsql'

" dbext
let g:dbext_default_profile_psql = 'type=PGSQL:host=192.168.64.4:port=5432:dbname=testdb:user=testdb'
let g:dbext_default_profile_dev_main = 'type=PGSQL:host=10.10.15.9:port=5434:dbname=bf_main:user=bfdba'
let g:dbext_default_profile_dev_asset = 'type=PGSQL:host=10.10.15.9:port=5433:dbname=bf_asset:user=bfdba'
let g:dbext_default_profile_dev_trade = 'type=PGSQL:host=10.10.15.9:port=5434:dbname=bf_trade:user=bfdba'
let g:dbext_default_profile_dev_audit = 'type=PGSQL:host=10.10.15.9:port=5434:dbname=bf_audit:user=bfdba'
let g:dbext_default_profile_dev_admin = 'type=PGSQL:host=10.10.15.9:port=5434:dbname=bf_admin:user=bfdba'
let g:dbext_default_profile_dev_market = 'type=PGSQL:host=10.10.15.9:port=5434:dbname=bf_market:user=bfdba'
let g:dbext_default_profile_local_testdb = 'type=PGSQL:host=127.0.0.1:port=5432:dbname=testdb:user=yihuang:passwd=123456'
let g:dbext_default_profile = 'local_testdb'


let g:gutentags_dont_load = 1


" purescript
let purescript_indent_case = 2
