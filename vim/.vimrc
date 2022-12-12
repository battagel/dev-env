set nocompatible              " be iMproved, required

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Colour Themes
Plugin 'tomasiser/vim-code-dark'
Plugin 'sainnhe/sonokai'
Plugin 'sonph/onehalf'
Plugin 'morhetz/gruvbox'
Plugin 'joshdick/onedark.vim'
Plugin 'savq/melange'
Plugin 'tomasr/molokai'

" Airline
Plugin 'vim-airline/vim-airline'

Plugin 'preservim/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'preservim/nerdcommenter' "Use /cc to comment lines
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'

Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

Plugin 'neoclide/coc.nvim', { 'branch': 'release'}

Plugin 'sheerun/vim-polyglot'
" Plugin 'mattn/emmet-vim' not currently needed
" Plugin 'tabnine/YouCompleteMe' Maybe doesnt work?
Plugin 'dense-analysis/ale'
Plugin 'vim-syntastic/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'christoomey/vim-tmux-navigator'
" Has to load after most plugins
Plugin 'ryanoasis/vim-devicons'
Plugin 'prettier/vim-prettier', {'do': 'yum install' }
Plugin 'junegunn/rainbow_parentheses.vim'

" Python specific
Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'
Plugin 'jiangmiao/auto-pairs'

" For Typescript
Plugin 'pangloss/vim-javascript'
" Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'HerringtonDarkholme/yats.vim'

" For GoLang
Plugin 'fatih/vim-go'

" Github Copilot
Plugin 'github/copilot.vim'

" To take a look at
" Changes the default vim command to a dashboard for ease of use
" Plugin 'glepnir/dashboard-nvim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Colour theme
if has('termguicolors')
  set termguicolors
endif

let g:sonokai_style = 'andromeda'
let g:sonokai_better_performance = 1

let g:sonokai_transparent_background=0
let g:sonokai_diagnostic_line_highlight=1
" Stop comments being italic - causes highlighting problem
let g:sonokai_disable_italic_comment=0
colorscheme sonokai


" Fix backspace not working issue
set backspace=indent,eol,start

" Line numbers on
set number
" Bell notification off
set belloff=all
" Turn on syntax highlighting
syntax on
" Enable filetype plugins
filetype plugin on

" Window and tab  navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap H :tabprevious<CR>
nnoremap L :tabnext<CR>

" Encoding type
set encoding=utf-8

" Clipboard
set clipboard=unnamed

" Mouse active
set mouse=a

" Set view command tab autocompletetion on 
set wildmenu

" Fold specific
" set foldmethod=indent

" Center on search
nnoremap n nzz
nnoremap N Nzz

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Nerd Tree
nnoremap <silent> <C-z> :NERDTreeToggle<CR>
nnoremap <silent> <C-x> :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden=1
let NERDTreeAutoDeleteBuffer = 1
let g:webdevicons_conceal_nerdtree_brackets = 1

" Tagbar
nnoremap <silent> <C-s> :TagbarToggle<CR>
" Fixed issue of empty tagbar
let g:tagbar_ctags_bin="/opt/homebrew/bin/ctags"
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }
" YATS
set conceallevel=1

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1

" Fuzzy Finder
nnoremap <C-p> :Files<Cr>

" Coc.nvim
let g:coc_disable_startup_warning = 1
" Run :CocInstall <package> to install new language support
" Run :CocList to view packages
" use <tab> for trigger completion and navigate to the next complete item
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-lists',
  \ 'coc-prettier',
  \ 'coc-pyright'
  \ ]

" \do performs a code action
nmap <leader>a <Plug>(coc-codeaction)
nmap <leader>d :CocDiagnostics<CR><C-w>k
nmap <leader>f :CocCommand prettier.formatFile<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" Auto error info / docs when hovering
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

" Fixed backspace issue
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Tab to select autocomplete
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Rainbow brackets use RainbowLoad and RainbowToggle to use
let g:rainbow#max_level = 16
" let g:rainbow#pairs = [['(', ')'], ['[', ']']]

" List of colors that you do not want. ANSI code or #RRGGBB
" let g:rainbow#blacklist = [233, 234]


" Status Line
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" Dashboard
let g:dashboard_default_executive ='fzf'

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_python_exec = 'python3'

" This will highlight bad white space live when coding - Kinda annoying
" highlight BadWhitespace ctermbg=red guibg=red
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
"au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
"au BufRead,BufNewFile *.py,*.pyw, set textwidth=100
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

let python_highlight_all=1

" YouCompleteMe
" let g:ycm_autoclose_preview_window_after_completion=1
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" hi Normal guibg=NONE ctermbg=NONE
