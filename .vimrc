" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'git@github.com:ervandew/supertab.git'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'altercation/vim-colors-solarized'
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-fugitive'
Plug 'jez/vim-ispc'
Plug 'junegunn/goyo.vim'

" vim vs. neovim
if has('nvim')
	" Typescript
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'jelera/vim-javascript-syntax'
	Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
	Plug 'Shougo/deoplete.nvim'
	Plug 'Shougo/denite.nvim'

	let g:deoplete#enable_at_startup = 1

	autocmd FileType typescript nnoremap <buffer> <C-]> :TSDef<CR>
	autocmd FileType typescript nnoremap <buffer> <Leader>t :TSType<CR>
	autocmd FileType typescript nnoremap <buffer> <Leader>d :TSDoc<CR>

	" Scala
	Plug 'buntec/neovim-scalavista', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Quramy/tsuquyomi'
	Plug 'leafgarland/typescript-vim'
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
" let g:materialbox_italic=1

colorscheme nord
let g:nord_italic=1
let g:nord_italic_comments=1
let g:nord_underline=1
let g:nord_uniform_diff_background=1

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

" supertab
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" Scala
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {
	\ 'scala': 'metals-vim'
	\}
let g:lsc_auto_map = {
	\ 'GoToDefinition': 'gd',
	\}

" set light mode?
if !empty($LC_LIGHT_BG)
	colorscheme default
	set background=light
	let g:airline_theme='light'
endif
