" * SOURCE (mostly): https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" Everything from "General" to "helper functions"
" are from the basic.vim config.
" Everything after that was added by me.
" I also removed a lot of things from the basic.vim config, 
" mostly because this started out as the config I used for 
" back when I had to use a Raspberry Pi (around early 2023) 
" for work, which I used vim on.
" If any comment starts with a * then that means I changed
" something from basic.vim
 
" --------------------------------------------------------

" THINGS TO INSTALL BEFORE USING THIS CONFIG:
" Windows:
" 	choco install ripgrep
" 	choco install mingw
" You might have to include mingw's bin folder to %PATH%
" Debian-based Linux:
" 	sudo apt install ripgrep
" 	sudo apt install xclip

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set regular expression engine automatically
set regexpengine=0

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" * Use DOS as the standard file type if the current OS is Windows, else use unix
if has('windows')  
	set ffs=dos,unix,mac
else
	set ffs=unix,dos,mac
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in git anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ \ \ Line:\ %l\ \ Column:\ %c

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Note to myself: Do :PlugInstall when adding a new plugin
call plug#begin()

" The most important one of all. Can't have a neovim config without this
Plug 'ThePrimeagen/vim-be-good'

" Easy way to install and use LSPs.
" I might use it in the future
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

" Telescope
" Also do `choco install ripgrep` in order for Telescope to ignore .git/*
" and .gitignore 
" IMPORTANT: Also install the MSVC toolchain through `choco install mingw` and
" 			 use mingw's gcc instead of cygwin's.
" 			 I had to learn this the hard way (https://github.com/nvim-treesitter/nvim-treesitter/issues/6894)
 Plug 'nvim-lua/plenary.nvim'
 Plug 'neovim/nvim-lspconfig'
 Plug 'nvim-tree/nvim-web-devicons'
" Telescope is the only reason I have Treesitter installed.
" When I have Treesitter in my config, Neovim is crashing numerous times
" for the wildest reasons. And when I un-Plug Treesitter, Neovim isn't crashing
" when I'm doing the same things that led to these crash.
" I can't even view the help page without the vimdoc parser installed...
" To add to that, Neovim completely freezes when I try to open Telescope on my Laptop
"if empty(glob("C:/thisOnlyExistsOnMyLaptop.txt")) || !has("unix")
	 "Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"endif
Plug 'nvim-telescope/telescope.nvim'

" I saw Primeagen having something like this.
" Keep in mind that https://github.com/dense-analysis/ale/issues/4642 exists and 
" 	https://github.com/dense-analysis/ale/pull/4738 hasn't been merged either.
" Ale slows down the process of going from insert mode to normal mode from almost
" 	instantly to 1 second.
" Plug 'dense-analysis/ale'

"A better Go experience
"Only Plug it if it's my Laptop or my PC at home
if empty(glob("C:\\thisOnlyExistsOnMyWorkPC.txt"))
 	Plug 'fatih/vim-go'
endif

" Use catppuccin on Windows and tender on WSL.
" It just feels weird for neovim to look the same
" on both Windows and WSL, when the terminals don't
" (Windows CMD being black and white,
" WLS Ubuntu being similiar to Canonical Aubergine (#300924)
if has("win16") || has("win32")
	Plug 'catppuccin/nvim'
else
	Plug 'jacoborus/tender.vim'
endif

" Found it on https://www.sethdaniel.dev/vim/plugins/ and I think it's kinda neat
" It unfortunately is slow on my Laptop
if !has("unix") || empty(glob("C:\\thisOnlyExistsOnMyLaptop.txt"))
	Plug 'joeytwiddle/sexy_scroller.vim'
endif

" gcc: Comment out a line
" gc + motion: Comment out target of a motion
" gcgc: Uncomment a line
Plug 'tpope/vim-commentary'

" It's time to use buffers...
Plug 'akinsho/bufferline.nvim', {'tag': '*'}

" I saw these on images related to neovim and
" never knew what these are called
Plug 'vim-airline/vim-airline'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => My own configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nu
set rnu

" 2 Years of vim/nvim usage finally led me to using
" a leader key
let mapleader = ','

" The recently pressed key/keys appear on the bottom 
" right corner when pressed
set showcmd

" This prevents the terminal's cursor being neovim's 
" cursor instead of the one it was meant to be after 
" exiting neovim.
" So now neovim uses the terminal's cursor.
" TL;DR: Neovim acts weird on Windows Terminal
autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q")

set guicursor=

" Switch nu and rnu depending on whether the window
" is focused or not 
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter	* if &nu && mode() != "i"	| set rnu | endif
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave 	* if &nu 					| set nornu | endif
augroup END

" -----------------

" y removes highlighting
nnoremap <silent>y :noh<CR>

" Enter the prefix for replacing text when leader + s 
" is pressed
nnoremap <leader>s :%s/

" leader + o inserts a new line at cursor
nmap <leader>o i<cr><Esc>

" It's a lot easier to type a colon on QWERTY
" than it is on QWERTZ,
" so enter command mode when the spacebar is pressed
nnoremap <space> :
"
" Change cwd to the path of the file
set autochdir

" Use the system clipboard to yank and paste
" ! TL;DR: INSTALL `xclip` WHEN ON WSL OR LINUX
" clipboard=unnamedplus slows down neovim on WSL a lot
" when something like xclip is not installed.
" You can't do anything about it, except install something
" like xlip, when  "-clipboard" appears when running
" `nvim --version`
"
" How can I tell that this is a problem?: https://www.reddit.com/r/neovim/comments/llw7d9/comment/gnsmfix/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
" Solution : https://www.reddit.com/r/neovim/comments/llw7d9/comment/h1ys5bs/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
set clipboard=unnamedplus

" Vim is adjusted for QWERTY which adds
" a few issues when using QWERTZ.
" Partial Source: https://unix.stackexchange.com/questions/257392/vim-with-foreign-qwertz-keyboard
nnoremap ü  ?
nnoremap ä  /

" I have never and will never use + and - to move up 
" and down a line.
" Also + is significantly more accessible
" than ~ on QWERTZ, so change the key for switching cases from ~ to +
map + ~
"
" The ö-key on QWERTZ is where : and ; are on QWERTY.
" I use the spacebar to go into command mode anyway.
nnoremap ö <cmd>Telescope find_files<cr>
nnoremap Ö <cmd>Telescope<cr>
nnoremap - <cmd>Telescope live_grep<cr>

" It nice on my home PC, laptop, AND my work PC
" I do prefer 2 different themes for 2 different OS'
" because it feels weird when neovim looks the same
" on 2 different OS'
if has("win16") || has("win32")  
 	colorscheme catppuccin-macchiato
	let g:airline_theme='catppuccin'
else
	colorscheme tender
	let g:airline_theme='tender'
endif

" Resize the window with Ctrl+w++ and Ctrl+w+-
" noremap <silent> <C-w>+ <cmd>resize +2<CR>
" noremap <silent> <C-w>- <cmd>resize -2<CR>
noremap <silent> <C-w>+ <cmd>vertical resize +5<CR>
noremap <silent> <C-w>- <cmd>vertical resize -5<CR>

" Enable the :Man command shipped inside Neovim's man filetype plugin.
" And map "man" to "Man". And yes, I know that user commands have to start
" with a capital letter but I don't really care
runtime ftplugin/man.vim
cabbrev man Man

" akinsho/bufferline.nvim needs this
set termguicolors

" Go to previous/next buffer with Ctrl+h and Ctrl+l
nmap <C-h> <cmd>bprev<cr>
nmap <C-l> <cmd>bnext<cr>

" Close buffer with Ctrl+w ctrl+w
nmap <C-w><cr> <cmd>Bclose<cr>

" I only learned about this while doing vimtutor for fun...
" How did I not know this before?
set undofile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language specific
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Rulers for Python and C++
" Python: PEP8 says 'Limit all lines to a maximum of 79 characters.
" 		  For (...) docstrings or comments, the line length should
" 		  be limited to 72 characters'
" Cpp: I have read for about 20 minutes or so that some people use
" 	   80 characters, some 120, so 100 is kind of a middle ground 
autocmd FileType python set colorcolumn=73,80
autocmd FileType c++ set colorcolumn=101

" Just in case
autocmd FileType cpp set colorcolumn=101

" Get the Golang documentation for the selected code when shift+k is pressed.
" The default functionality of shift+k is still present for every other filetype
au filetype go vnoremap K <cmd>GoDoc<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Lua
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Lastly, load the lua file
lua require('init')
