set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'airblade/vim-gitgutter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'rhysd/vim-clang-format'
Plugin 'tpope/vim-sleuth'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'pangloss/vim-javascript'
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'styled-components/vim-styled-components', { 'branch': 'main' }
Plugin 'jparise/vim-graphql'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'npip99/vim-voxelscript'
Plugin 'junegunn/fzf' " Must install fzf through plugin or PATH

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth()'
let g:python_indent.closed_paren_align_last_line = v:false

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ----- general settings -----

map <Space> <Leader>

" Faster window movement with CTRL+direction
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Alt-j/k inserts an empty line above/below the current line, without moving the cursor.
nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

set backspace=indent,eol,start
set ruler
set number
set relativenumber
set showcmd
set incsearch
set hlsearch
set cursorline

" ----- fzf settings -----

nnoremap <Leader>ff :FZF<CR>
" Use <C-j> / <C-k> to navigate fzf window
let $FZF_DEFAULT_OPTS = '--bind "ctrl-j:down,ctrl-k:up,alt-j:preview-down,alt-k:preview-up"'

" ----- syntax highlighter settings -----
syntax enable

" multi-line case in python
autocmd FileType python syn match pythonConditional "^\s*\zscase\%(\s\+.*(.*$\)\@="

colorscheme onehalfdark
let g:airline_theme='onehalfdark'

" "hi!" vs "hi" https://stackoverflow.com/a/31146436
hi CursorLineNr ctermfg=139 ctermbg=237
hi LineNr ctermfg=139
hi Comment ctermfg=71
hi String ctermfg=180
hi! link Number String
hi Identifier ctermfg=117
hi Special ctermfg=168
hi Function ctermfg=229
hi Constant ctermfg=39
hi Escape ctermfg=208
hi Type ctermfg=43
hi! link Keyword Statement

hi! link pythonEscape Escape
hi! link vimEscape Escape
hi! link PreProc Identifier
hi! link PreCondit Identifier
hi! link pythonBuiltin Constant

" Show syntax group stack
function! Syn ()
  echo 'Highlight group: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . "\n" . 'ctermfg: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg#') . "\n" . 'guifg: ' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'fg#')
endfunction
function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction
" `:call SynStack()` to see syntax highlight group stacktrace
" :CocCommand semanticTokens.checkCurrent
" :so $VIMRUNTIME/syntax/hitest.vim

" Make VIM use the gnome clipboard for yanks and pastes
set clipboard=unnamed

" Map escape-A to alt-A, to fix issue where alt is sent using escape. If
" there is a 25 ms gap, vim presumes you meant to first press escape, and then
" A.
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=25

let g:c_no_curly_error=1

" ----- coc settings -----
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-basedpyright'
  \ ]
hi CocInlayHint term=bold cterm=italic ctermfg=245 gui=italic
hi! link CocSemTypeDecorator Function
hi! link CocSemTypeTypeParameter Type " Type created with `from typing import TypeVar`
hi! link CocSemTypeClass Type
hi! link CocSemNamespace Type
hi! link CocSemTypeNamespace CocSemNamespace

" TextEdit might fail if hidden is not set.
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Show 2 signcolumns, for diagnostics/gitgutter + lineno
set signcolumn = "yes:2"

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
"" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
""                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
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

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selection)
nmap <leader>a  <Plug>(coc-codeaction-cursor)

" Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

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

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

" ----- airline settings -----
set laststatus=2 " Use airline when one file is open

" ----- nerdtree settings -----
" Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" Start NERDTree
autocmd VimEnter * NERDTree
" Jump to the main window.
autocmd VimEnter * wincmd p
" Highlights
hi! link NERDTreeHelp Comment

" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = "X"
let g:syntastic_warning_symbol = "-"
let g:syntastic_cpp_config_file = ".syntastic_cpp_config"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./.tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" ----- majutsushi/tagbar settings -----
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" ----- auto-pairs settings -----
let g:AutoPairsMapSpace = 0
let g:AutoPairsMultilineClose = 0

" ----- clang-format settings -----
"
let g:clang_format#style_options = {"Standard" : "Auto"}

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
autocmd FileType c ClangFormatAutoEnable

