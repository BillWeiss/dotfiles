" .vimrc

call pathogen#infect()

" use vim, not vi
set nocp
" title a terminal window
set title
" more contrast
set background=dark
" always autoindent
set ai
" no backups
set nobackup
set tabstop=4
set sts=4
set et
set expandtab
set showmatch
set showcmd
syntax enable
set tw=74
set vb
set shiftwidth=4
set ruler
set bs=2
"colorscheme zenburn
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

set viminfo='100,f1

"     wildmenu!  this makes use of the command line to show
"     possible matches on buffernames and filenames - yay!
if version>=508
	set wildmenu
	set wildmode=list:longest,full
endif

if has("autocmd")

 " always generate (and use) view files
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview

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
  "   For HTML, treat <(stuff)> as comment for formatting
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent 
  	\comments=sr:/*,mb:*,el:*/,://
  autocmd FileType html   set formatoptions=tcql comments=s:<,e:> 
  	\sts=2 ts=2 shiftwidth=2 expandtab
  autocmd FileType xhtml  set formatoptions=tcql comments=s:<,e:> 
  	\sts=2 ts=2 shiftwidth=2 expandtab
 augroup END

 au BufNewFile,BufRead /tmp/mutt* set syntax=mail filetype=mail 
 au BufNewFile,BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d/^$
 au BufNewFile,BufRead draft_* set syntax=xhtml filetype=xhtml

 " Markdown likewise doesn't appreciate hard-newlines in files
 autocmd BufRead *.markdown set tw=0
 autocmd BufRead *.md set tw=0

 au BufNewFile,BufRead *.pp set ts=2 et sw=2 sts=2 filetype=puppet
 
endif " has("autocmd")

setlocal spell spelllang=en_us
