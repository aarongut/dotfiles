" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

" Helpful information: cursor position in bottom right, line numbers on left
set ruler
set number

" Enable filetype detection and syntax hilighting
syntax on
filetype on
filetype indent on
filetype plugin on

" Indent as intelligently as vim knows how
set smartindent

" Show multicharacter commands as they are being typed
set showcmd
set laststatus=2
set noshowmode
set title

" Search betterer
set incsearch
set hlsearch
set ignorecase
set smartcase

colorscheme distinguished
set background=dark

execute pathogen#infect()

" highlight long lines (over 80 char)
if exists('+colorcolumn')
    set colorcolumn=80
else
endif

if exists('+mouse')
    set mouse=a
else
endif

let g:airline_powerline_fonts=1

" NERDTree binding
map <C-n> :NERDTreeToggle<CR>

" easytags prefers local tag files
set tags=./tags
let g:easytags_dynamic_files = 1

" merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" set light mode?
if !empty($LC_LIGHT_BG)
	colorscheme solarized
	set background=light
endif
