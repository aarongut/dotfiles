" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-fugitive'
Plug 'jez/vim-ispc'
Plug 'junegunn/goyo.vim'
Plug 'powerman/vim-plugin-AnsiEsc'

" vim vs. neovim
if has('nvim')
	" Typescript
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'jelera/vim-javascript-syntax'
	Plug 'Shougo/deoplete.nvim'
	Plug 'neovim/nvim-lspconfig'

	"let g:deoplete#enable_at_startup = 1
else
	" Vim-only plugins here
	" What is the best path forward for the best pattern not found
endif

call plug#end()

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

"let g:nord_italic=1
"let g:nord_italic_comments=1
"let g:nord_underline=1
"let g:nord_uniform_diff_background=1
"colorscheme nord


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
if executable('rg')
	let g:ackprg = 'rg --vimgrep'
endif

nmap <Leader>a :Ack!<Space>

" quickfix
nmap <Leader>c :cclose<CR>
nmap <Leader>C :copen<CR>

" set light mode?
if !empty($LC_LIGHT_BG)
	colorscheme default
	set background=light
	let g:airline_theme='light'
endif

" markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'scala', 'typescript', 'javascript']
