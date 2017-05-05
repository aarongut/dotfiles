" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

execute pathogen#infect()

" Enable filetype detection and syntax hilighting
syntax on
filetype on
filetype indent on
filetype plugin on
set smartindent

" Search betterer
set incsearch
set hlsearch
set ignorecase
set smartcase

" Visual setup
set number
set noshowmode
set title
set showcmd
set laststatus=2
set background=dark
colorscheme materialbox
set t_ut=
let g:airline_theme='lucius'
let g:airline_powerline_fonts=1

" highlight long lines (over 80 char)
if exists('+colorcolumn')
	set colorcolumn=80
else
endif

if exists('+mouse')
	set mouse=a
else
endif

" F5 to trim trailing whitespace
map <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" NERDTree binding
map <C-n> :NERDTreeToggle<CR>

" easytags prefers local tag files
set tags=./tags,../tags,../../tags,../../../tags
let g:easytags_dynamic_files = 1

" merlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"

" set light mode?
if !empty($LC_LIGHT_BG)
	colorscheme default
	let g:airline_theme='solarized'
	set background=light
endif
