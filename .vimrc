" Plugin-free config that works on any vim. Neovim sources this and
" layers plugins and LSP on top in ~/.config/nvim/init.lua.
set nocompatible
set backspace=indent,eol,start

syntax on
filetype plugin indent on
set smartindent

" Search
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
set notermguicolors
silent! colorscheme materialbox
set t_ut=

" highlight long lines (over 80 char)
if exists('+colorcolumn')
	set colorcolumn=80
endif

if exists('+mouse')
	set mouse=a
endif

" look for tags file along path
set tags=tags;/

" swapfiles to /tmp
set directory=/tmp

" F5 to trim trailing whitespace
map <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" quickfix
nmap <Leader>c :cclose<CR>
nmap <Leader>C :copen<CR>

" set light mode?
if !empty($LC_LIGHT_BG)
	colorscheme default
	set background=light
endif

" markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'scala', 'typescript', 'javascript']
