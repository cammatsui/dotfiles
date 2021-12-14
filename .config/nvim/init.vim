"  ________  _____ ______      
" |\   ____\|\   _ \  _   \      
" \ \  \___|\ \  \\\__\ \  \   		Cameron Matsui
"  \ \  \    \ \  \\|__| \  \  		@cammatsui
"   \ \  \____\ \  \    \ \  \ 		github.com/cammatsui
"    \ \_______\ \__\    \ \__\     init.vim	
"     \|_______|\|__|     \|__|				


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SETUP PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $HOME/.config/nvim/vim-plug/plugins.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASICS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set number
set relativenumber
set nowrap
set smartindent
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLORS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set termguicolors
colorscheme monokai_pro

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LIGHTLINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
set noshowmode

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIMTEX
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexrun'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REMAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Change splits
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" alt + hjkl to resize windows
nnoremap <M-j>      :resize -2<CR>
nnoremap <M-k>      :resize +2<CR>
nnoremap <M-h>      :vertical resize -2<CR>
nnoremap <M-l>      :vertical resize +2<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv
