execute pathogen#infect()

set termguicolors
colorscheme solarized8_flat

let mapleader = ","
tnoremap <Esc> <C-\><C-n>
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
set splitbelow
set splitright

" plugins
nnoremap <C-L> :BufExplorer<CR>

" ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" vim-grepper
nnoremap <leader>g :Grepper -tool git -highlight<cr>
nnoremap <leader>G :Grepper -tool rg -highlight<cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" ale
au FileType haskell let g:ale_linters.haskell = ['hlint']
nnoremap <silent> <leader>aj :ALENext<cr>
nnoremap <silent> <leader>ak :ALEPrevious<cr>

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
