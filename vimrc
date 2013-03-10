" Preamle ---------------------------------------------------------------------- {{{
" Use Vim settings, rather than vi sesstings
" This must be first, because it changes other options as a side effect.
set nocompatible

" turn on pathogen vim plugin
call pathogen#infect()

" }}}
" Basic Settings --------------------------------------------------------------- {{{
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
	syntax on
endif

let mapleader="\\"                                " set leader
set textwidth=0                                   " don't wrap text
set autoindent                                    " set automatic indentingset automatic indenting
set history=50                                    " keep 50 lines of command line history
set nowrap                                        " turn off line wrapping.
set showcmd                                       " displays incomplete commands
set showmode                                      " display the mode you're in.
set backspace=indent,eol,start                    " allow backspacing over everything in insert mode
set hidden                                        " handle multiple buffers better.
set number                                        " display line numbers
set ruler                                         " show the cursor position all the time
set cursorline                                    " highlight current line
hi CursorLine cterm=NONE ctermfg=NONE ctermbg=235 guibg=#222222
" hi SpellLocal cterm=NONE ctermfg=NONe ctermBG=235 guibg=#333333
autocmd WinEnter * setlocal cursorline            " Show current line highlight when entering a window
autocmd WinLeave * setlocal nocursorline          " Remove current line highlight when leaving a window
" This unsets the last search pattern register by hitting return
nnoremap <CR> :noh<CR><CR>
set title                                         " change terminals title
set visualbell                                    " no beeping.
set laststatus=2                                  " show the status line all the time
set background=dark
au FocusLost * :wa                                " Automatically save files when they lose focus
au VimResized * :wincmd =                         " Resize splits when the window is resized
set pastetoggle=<f2>
set list
" set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
" set listchars=tab:│┈ ,eol:¬,extends:❯,precedes:❮
set listchars=tab:┊\ ,eol:¬,extends:❯,precedes:❮

" }}}
" Absolute/Relative Line Numbers ----------------------------------------------- {{{
function! NumberToggle()
	if(&relativenumber == 1)
		set number
	else
		set relativenumber
	endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
" }}}
" WildMenu Completion ---------------------------------------------------------- {{{
set wildmenu                                      " enhanced command line completion.
set wildmode=list:longest,list:full                " complete files like a shell.
set wildignore+=.hg,.git,.svn                     " Version control
set wildignore+=*.aux,*.out,*.toc                 " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg    " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest  " compiled object files
set wildignore+=*.spl                             " compiled spelling word lists
set wildignore+=*.sw?                             " Vim swap files
set wildignore+=*.DS_Store                        " OSX bullshit
" }}}
" Line Return ------------------------------------------------------------------ {{{
augroup line_return
	au!
	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	" Also don't do it when the mark is in the first line, that is the default
	" position when opening a file.
	au BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\   exe "normal! g`\"" |
	\ endif
augroup end
" }}}
" Tabs ------------------------------------------------------------------------- {{{
set tabstop=2                                     " set tab size
set shiftwidth=2                                  " set how man columns text gets indented with indent operations
set noexpandtab                                   " dont auto convert tabs into spaces
" }}}
" Backups/Swap Files/Undo File ------------------------------------------------- {{{
set nobackup                                      " don't make a backup before overwritting a file.
set nowritebackup                                 " and again.
set undofile                                      " persistent undo
set undoreload=10000
set directory=$HOME/.vim/tmp/swap//               " keep swap files in one location
set undodir=$HOME/.vim/tmp/undo//                 " undo files location
set backupdir=$HOME/.vim/tmp/backup//             " backups location
" }}}
" Searching and Movement ------------------------------------------------------- {{{
set ignorecase                                    " Case-insensitive searching
set smartcase                                     " Search case-insensitive when search string is all-lowercase,
                                                  " otherwise search case-sensitive
set incsearch                                     " do incremental searching
set hlsearch                                      " highlight matches
set showmatch
set scrolloff=4                                   " Lines of context around the cursor.
set sidescroll=1
set sidescrolloff=10
set virtualedit+=block
" Highlight current word matches
autocmd CursorMoved * silent! exe printf('match SpellLocal /\<%s\>/', expand('<cword>'))
" }}}
" DiffOrig --------------------------------------------------------------------- {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
			\ | wincmd p | diffthis
endif
" }}}
" Pretty Format xml ------------------------------------------------------------ {{{
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
" }}}
" Mappings --------------------------------------------------------------------- {{{
map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>
" NERDTree configuration
map <Leader>n :NERDTreeToggle<CR>                 " Map \n to toggle tree navigation
" Tabs ------------------------------------------------------------------------- {{{
map <Leader>tt :tabnew<cr>
map <Leader>te :tabedit
map <Leader>tc :tabclose<cr>
map <Leader>to :tabonly<cr>
map <Leader>tn :tabnext<cr>
map <Leader>tp :tabprevious<cr>
map <Leader>tf :tabfirst<cr>
map <Leader>tl :tablast<cr>
map <Leader>tm :tabmove
" }}}
" }}}
" Folding ---------------------------------------------------------------------- {{{
set foldlevelstart=0
set foldopen=insert,jump,mark,percent,tag,search

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf 

" "Refocus" folds
nnoremap ,z zMzvzz

function! MyFoldText() " {{{
	let line = getline(v:foldstart)
	
	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 3
	let foldedlinecount = v:foldend - v:foldstart
	
	" expand tabs into spaces
	let onetab = strpart('          ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')
	
	let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
	return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" FileType Specific ------------------------------------------------------------ {{{
au FileType c,cpp,java,php,js set cindent
" Ruby {{{
au BufNewFile,BufRead *.rb,*.rbw,*.gem,*.gemspec set filetype=ruby
" Rakefile
au BufNewFile,BufRead [rR]akefile,*.rake         set filetype=ruby
" IRB config
au BufNewFile,BufRead .irbrc,irbrc               set filetype=ruby
" Rackup
au BufNewFile,BufRead *.ru                       set filetype=ruby
" Capistrano
au BufNewFile,BufRead Capfile                    set filetype=ruby
" Bundler
au BufNewFile,BufRead Gemfile                    set filetype=ruby
" Autotest
au BufNewFile,BufRead .autotest                  set filetype=ruby
" eRuby
au BufNewFile,BufRead *.erb,*.rhtml              set filetype=eruby
" }}}
" Vim {{{
augroup ft_vim
	au!
		au FileType vim setlocal foldmethod=marker
augroup END
" }}}
" Javascript/Json {{{
augroup ft_javascript
	au!
		au BufNewFile,BufRead *.js set filetype=javascript syntax=jquery
		au BufNewFile,BufRead *.json set filetype=javascript
augroup end
" }}}
" Yacc {{{
augroup ft_yacc
	au!
		au BufNewfile,BufRead *ypp set filetype=yacc
augroup end
" }}}
" }}}
" Color Scheme ----------------------------------------------------------------- {{{
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
colorscheme solarized                         " Set colors
" }}}
" Plugin Settings -------------------------------------------------------------- {{{
" Local vimrc {{{
let g:localvimrc_ask=0                        " dont ask to source local vim rcs
" }}}
" Indent Guides {{{
let g:indent_guides_auto_colors = 0 
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=lightgrey ctermbg=235
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgrey  ctermbg=black
" }}}
" }}}
" Environments (GUI/Consoloe) -------------------------------------------------- {{{
if has('gui_running')
else
	" In many terminal emulators the mouse works just fine, thus enable it.
	if has('mouse')
		set mouse=a
	endif
endif
" }}}
" Unused ----------------------------------------------------------------------- {{{
" For all text files set 'textwidth' to 78 characters.
" autocmd FileType text setlocal textwidth=78
" let g:Powerline_symbols='fancy'
" set nofoldenable                            " turn off automatic code folding
" }}}
