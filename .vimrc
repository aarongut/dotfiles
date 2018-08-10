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
let g:materialbox_italic=1
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

" look for tags file along path
set tags=tags;/

" swapfiles to /tmp
set directory=/tmp


" F5 to trim trailing whitespace
map <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" NERDTree binding
map <C-n> :NERDTreeToggle<CR>
nmap <Leader>f :NERDTreeFind<CR>

" FZF
set rtp+=/usr/local/opt/fzf
nmap <C-P> :Files<CR>
nmap <C-p> :GFiles<CR>

" Ack
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

nmap <Leader>a :Ack!<Space>

" quickfix
nmap <Leader>c :cclose<CR>
nmap <Leader>C :copen<CR>

" supertab
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" set light mode?
if !empty($LC_LIGHT_BG)
	colorscheme default
	let g:airline_theme='solarized'
	set background=light
endif
