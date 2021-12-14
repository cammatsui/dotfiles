"  ________  _____ ______      
" |\   ____\|\   _ \  _   \      
" \ \  \___|\ \  \\\__\ \  \   		Cameron Matsui
"  \ \  \    \ \  \\|__| \  \  		@cammatsui
"   \ \  \____\ \  \    \ \  \ 		github.com/cammatsui
"    \ \_______\ \__\    \ \__\		plugins.vim
"     \|_______|\|__|     \|__|				

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Lightline
    Plug 'itchyny/lightline.vim'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " TypeScript highlighting
    Plug 'leafgarland/typescript-vim'
    " Java highlighting  
    Plug 'uiiaoo/java-syntax.vim'
    " Autocompletion
    Plug 'neoclide/coc.nvim'
    " Linting
    Plug 'dense-analysis/ale'
    " Git integration
    Plug 'tpope/vim-fugitive'
    " Auto documentation
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    " Smooth scrolling
    Plug 'psliwka/vim-smoothie'
    " NerdTree Stuff
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'
    " CSS Color preview
    Plug 'ap/vim-css-color'

call plug#end()
