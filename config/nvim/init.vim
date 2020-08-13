if &compatible
  set nocompatible
endif
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'derekwyatt/vim-fswitch'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-highlightedyank'
Plug 'mileszs/ack.vim'
Plug 'morhetz/gruvbox'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rbgrouleff/bclose.vim'
Plug 'rhysd/vim-clang-format'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
 
call plug#end()

" Ignore .o files in places like ctrlp
set wildignore+=*.o

" Make vim try to use colors that look good on a dark background
set background=dark

" Colorscheme setup
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" Yank highlighting
hi HighlightedyankRegion cterm=reverse

" Searching
set ignorecase " ignore case when searching...
set smartcase  " ...unless differing cases specified

" Remap search keys so that search results appear in the middle of the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap <F3> :set hlsearch!<CR>
nnoremap <M-/> :nohl<CR>

" Remap page up/down to be sensible.
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>
set nostartofline

" Line numbering
set number

" Automatically rebalance splits if the terminal size changes
autocmd VimResized * exe "normal \<c-w>="

" Tabs -> spaces, 4 space width, indents, text wrap at 120 characters, but turn off wrapping by default
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set tw=120
set formatoptions-=t

" Switch from foo.h -> foo_inline.h -> foo.cpp
au! BufEnter *.cpp let b:fswitchdst = 'h'
au! BufEnter *.h let b:fswitchdst = 'h,cpp' | let b:fswitchfnames = '/$/_inline/'
au! BufEnter *_inline.h let b:fswitchdst = 'cpp' | let b:fswitchfnames = '/_inline$//'
map <C-c> :FSHere<CR>

" Projectionist alternate file
" Unfortunately, projectionist doesn't remember where you were in the file when switching back. Until
" that's fixed, I can't use it.
" map <C-c> :A<CR>

" Airline
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.notexists = '∉'

" commentary setup
autocmd FileType cpp set commentstring=//\ %s

" Ripgrep
if executable('rg')
    let g:ackprg = 'rg --vimgrep'
endif

" Shorten updatetime, this makes the git gutter update faster. This is in milliseconds.
set updatetime=250

" Make navigator use Meta instead of Control. Control-h can have issues, depending on
" the terminal
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>

" cindent setup
" N-s: don't indent inside namespaces
" g0: don't indent C++ scope declarations
" i0: don't indent cases inside switch
set cindent
set cino=N-s,g0,i0

" Don't continue comments onto the next line when hitting enter.
set formatoptions-=cro

" Clang formatting
let g:clang_format#style_options = {
    \ "BasedOnStyle": "LLVM",
    \ "IndentWidth": 4,
    \ "AlignAfterOpenBracket": "DontAlign",
    \ "AllowShortBlocksOnASingleLine": "true",
    \ "AllowShortCaseLabelsOnASingleLine": "true",
    \ "AllowShortFunctionsOnASingleLine": "Inline",
    \ "AllowShortIfStatementsOnASingleLine": "false",
    \ "AllowShortLoopsOnASingleLine": "false",
    \ "BreakBeforeBinaryOperators": "NonAssignment",
    \ "BreakBeforeBraces": "Custom",
    \ "BreakConstructorInitializers": "BeforeComma",
    \ "BraceWrapping": {
    \ "    AfterFunction": "true",
    \ "    BeforeElse": "true",
    \ },
    \ "ColumnLimit": 120,
    \ "FixNamespaceComments": "true",
    \ "IndentCaseLabels": "true",
    \ "IndentPPDirectives": "AfterHash",
    \ "PointerAlignment": "Middle",
    \ "UseTab": "Never",
    \ "AccessModifierOffset": -4,
    \ "AlwaysBreakTemplateDeclarations": "Yes",
    \ }

au VimEnter * command! -bang -nargs=* AgDir :call s:Ag(<bang>0, <f-args>)
function! s:Ag(bang, ...)
    let terms = []
    let glob = ''
    let i = 0
    while i < a:0
        let arg = a:000[i]
        if arg == '-g'
            let i += 1
            let glob = '-g '.shellescape(a:000[i])
        else
            call add(terms, arg)
        endif
        let i += 1
    endwhile
    let terms = glob.' '.shellescape(join(terms))
    call fzf#vim#grep(
                \ 'rg --column --line-number --no-heading --color=always --smart-case '.terms, 1,  
                \ a:bang ? fzf#vim#with_preview('up:60%')
                \ : fzf#vim#with_preview('right:50%:hidden', '?'),
                \ a:bang)
endfunction

" FZF
map <C-p>   :FZF<CR>
map <M-p>   :Buffers<CR>
map <C-M-p> :History<CR>
map <C-r>   :AgDir 

nnoremap <leader>p :call fzf#vim#files('.', {'options':'--query '.expand('<cWORD>')})<CR>

" Rust
let g:rustfmt_autosave = 1

" Git Gutter
let g:gitgutter_max_signs=2000

