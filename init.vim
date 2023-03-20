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
set autoread
set textwidth=120

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

  " custom typescript formats
  au FileType typescript set noet
augroup END

" bufexplorer
let g:bufExplorerShowDirectories=0
let g:bufExplorerDisableDefaultKeyMapping=1
nmap <c-l> :BufExplorer<CR>

" fugitive
command GdiffInTab tabedit %|Gdiffsplit

" ale
au FileType haskell let g:ale_linters.haskell = ['stack-build']
nnoremap <silent> <leader>aj :ALENext<cr>
nnoremap <silent> <leader>ak :ALEPrevious<cr>
let g:ale_linters = {'go': ['gometalinter'], 'cpp': ['ccls']}
let g:go_fmt_fail_silently = 1  " https://github.com/w0rp/ale/issues/609
let g:ale_echo_msg_format = '%linter% says %s'
let g:go_fmt_command = "goimports"
let g:ale_fixers = {'python': ['black', 'isort'], 'nix': ['nixpkgs-fmt'], 'cpp': ['clang-format']}
let g:ale_fix_on_save = 1
let g:go_gopls_gofumpt = 1

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
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Re-map keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

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
let g:Lf_ShortcutF = "<leader>f"
let g:Lf_ShortcutB = ""
nnoremap <silent> <leader>g :<C-U><C-R>=printf("Leaderf! rg -w %s", expand('<cword>'))<CR><CR>
nnoremap <silent> <leader>G :<C-U><C-R>=printf("Leaderf! rg %s", expand('<cword>'))<CR>
xnoremap <silent> <leader>g :<C-U><C-R>=printf("Leaderf! rg -F -w -e %s ", leaderf#Rg#visual())<CR><CR>
xnoremap <silent> <leader>G :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
" nnoremap <silent> <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
" nnoremap <silent> <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
nnoremap <silent> <leader>b :<C-U>Leaderf! buffer --bottom<CR>
nnoremap <silent> <leader>r :<C-U>Leaderf! rg --recall<CR>

" gutentags/gutentags_plus
let g:gutentags_enabled = 0
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

" markdown
augroup Markdown
  autocmd!
  autocmd FileType markdown set formatoptions+=a
  autocmd Filetype * if &ft!="markdown"| set formatoptions-=a |endif
augroup END
