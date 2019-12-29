filetype off
execute pathogen#infect()

" defaults for vim only.
filetype plugin indent on
syntax enable
syntax on
set laststatus=2
set fileencodings=utf-8,gbk
set hlsearch
set incsearch
set nrformats-=octal

set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

set sw=4 ts=4 et
set splitbelow
set splitright

nnoremap j gj
nnoremap k gk
" swap :tag and :tselect
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
nnoremap g<c-]> <c-]>
vnoremap g<c-]> <c-]>

" common key bindings
let mapleader = ","
nnoremap <leader><CR> :noh\|hi Cursor guibg=red<CR>
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>l :setl number!<CR>
nnoremap <Leader>o :set paste!<CR>

" clipboard
nnoremap <leader>y "*y
vnoremap <leader>y "*y
nnoremap <leader>d "*d
vnoremap <leader>d "*d
nnoremap <leader>p "*p
vnoremap <leader>p "*p

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" colorschema
set termguicolors
colorscheme solarized8_flat

" terminal
augroup term
  au!
  au BufWinEnter,WinEnter term://* exec 'normal! i'
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

" haskell-vim
let g:haskell_indent_if = 2  " Align 'then' two spaces after 'if'
let g:haskell_indent_before_where = 2  " Indent 'where' block two spaces under previous body
let g:haskell_indent_case_alternative = 1  " Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_let_no_in = 0  " Only next under 'let' if there's an equals sign

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

" rust
let g:rustfmt_autosave = 1
let g:rust_fold = 1

" pgsql
let g:sql_type_default = 'pgsql'

" purescript
let purescript_indent_case = 2

" rtf
let g:copy_as_rtf_using_local_buffer = 1

" coc
set hidden
set cmdheight=2
set updatetime=300
set shortmess+=c

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Re-map keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap gf <Plug>(coc-fix-current)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

setl formatexpr=CocAction('formatSelected')
augroup mygroup
  autocmd!
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " go format
  autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')
augroup end

command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" golang
let g:go_def_mapping_enabled = 0

" open Typora
if has('mac')
  function! s:typora_launch()
      " Launch Typora
      call system("open -a Typora \"" . expand("%") . "\"")
      setl autoread
  endfunction

  command! Typora call s:typora_launch()
endif

" leaderf
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>b :<C-U><C-R>=printf("Leaderf! buffer %s", "")<CR><CR>
noremap <leader>g :<C-U><C-R>=printf("Leaderf! rg -w %s", expand('<cword>'))<CR><CR>
noremap <leader>G :<C-U><C-R>=printf("Leaderf! rg %s", expand('<cword>'))<CR>
xnoremap <leader>g :<C-U><C-R>=printf("Leaderf! rg -F -w -e %s ", leaderf#Rg#visual())<CR><CR>
xnoremap <leader>G :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>

" gutentags/gutentags_plus
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['.git', '.root']
let g:gutentags_cache_dir = expand('~/.cache/tags')
let g:gutentags_plus_switch = 1
noremap <silent> <leader>ss :GscopeFind s <C-R><C-W><cr>
noremap <silent> <leader>sg :GscopeFind g <C-R><C-W><cr>
noremap <silent> <leader>sc :GscopeFind c <C-R><C-W><cr>
noremap <silent> <leader>st :GscopeFind t <C-R><C-W><cr>
noremap <silent> <leader>se :GscopeFind e <C-R><C-W><cr>
noremap <silent> <leader>sf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>si :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
noremap <silent> <leader>sd :GscopeFind d <C-R><C-W><cr>
noremap <silent> <leader>sa :GscopeFind a <C-R><C-W><cr>

" nerdtree
map <c-n> :NERDTreeToggle<CR>
