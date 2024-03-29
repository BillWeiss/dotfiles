" .vimrc

" Turn on Vundle instead of the old pathogen
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Install some Vundles
Plugin 'editorconfig/editorconfig-vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'dense-analysis/ale'
Plugin 'hashivim/vim-terraform'
Plugin 'vim-syntastic/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'
Plugin 'leafgarland/typescript-vim'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'cespare/vim-toml'
Plugin 'jvirtanen/vim-hcl'
Plugin 'tpope/vim-fugitive'

" Don't do any Vundling after this
call vundle#end()
filetype plugin indent on

" use vim, not vi
set nocompatible
" title a terminal window
set title
" more contrast
set background=dark
" always autoindent
set autoindent
" don't litter backup files around everywhere
set nobackup
" I have strong feelings about tabs
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=0 " use the value of tabstop
" highlight matches of the last search
set showmatch
" show the command in the last line of the window
set showcmd
" syntax highlighting is great
syntax enable
" lines should be no more than 74 characters wide
set textwidth=74
" flash the screen instead of dinging
set visualbell
" show line and column number in the menu bar
set ruler
" allow backspacing over autoindent, line breaks, and start-of-insert
set backspace=indent,eol,start

" Solarized colorscheme
if filereadable(expand("\~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
    " all my terminals are 256-color safe, it's 2020
    let g:solarized_termcolors=256
    " my terminals are frequently transparent, support that
    let g:solarized_termtrans=1
    colorscheme solarized
endif

" read a .viminfo file on start, remember 100 files, store filemarks
set viminfo='100,f1

" wildmenu uses the command line to show possible matches on buffernames and
" filenames
if version>=508
	set wildmenu
	set wildmode=list:longest,full
endif

" filetype-specific commands
if has("autocmd")
 " In text files, always limit the width of text to 74 characters
 autocmd BufRead *.txt set tw=74

 " in rc files, don't mangle lines
 autocmd BufRead .*rc set tw=0
 autocmd BufRead .* set tw=0

 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent
    \ comments=sr:/*,mb:*,el:*/,://
 augroup END

 autocmd FileType html   set formatoptions=tcql comments=s:<,e:>
    \ sts=2 ts=2 shiftwidth=2 expandtab
 autocmd FileType xhtml  set formatoptions=tcql comments=s:<,e:>
    \ sts=2 ts=2 shiftwidth=2 expandtab

 autocmd BufNewFile,BufRead /tmp/mutt* set syntax=mail filetype=mail
 autocmd BufNewFile,BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d/^$
 autocmd BufNewFile,BufRead draft_* set syntax=xhtml filetype=xhtml

 " Markdown likewise doesn't appreciate hard-newlines in files
 autocmd BufRead *.markdown set tw=0
 autocmd BufRead *.md set tw=0

 autocmd BufNewFile,BufRead *.pp set ts=2 et sw=2 sts=2 filetype=puppet

 autocmd FileType yaml set ts=2 sts=2

endif " has("autocmd")

" spellchecking on, in US english
setlocal spell spelllang=en_us

" Airline config
" Airline is a fancy status line
"
" always show a status line
set laststatus=2
" these won't do anything if it's not installed
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline#extensions#ale#enabled = 1

" This tests for, as you might expect, if there's a GUI going
if has("gui_running")
    set gfn=Menlo-Regular:h15
    set anti
endif " has ("gui_running")

" Do some terraform magic
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" This makes pylint use the local python (so it works in a venv)
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_checkers = ['python']
