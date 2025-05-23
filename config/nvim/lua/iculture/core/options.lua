vim.cmd([[
	set path+=**
	set cc=100
	set wildignore+=**/node_modules/*
	set wildignore+=**/.git/*
	set wildignore+=*.log*
	set wildignore+=*.map*
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set expandtab
	set scrolloff=8
	set relativenumber nu
	set wrap
	set linebreak
	set breakindent
	set smartindent
	set autoindent
	set hidden
	set nobackup
	set noerrorbells
	set cursorline
	set noswapfile
	set undofile
	set incsearch
	set splitbelow
	set splitright
	set undodir=~/.local/share/undo
	set mouse=a
	set iskeyword=@,48-57,_,192-255,$
	autocmd FileType * setlocal expandtab
	filetype plugin indent on
    autocmd BufNewFile,BufRead *.gls set filetype=glsl
]])

vim.o.foldenable = false
-- vim.o.foldcolumn = ''
-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.o.foldtext = require('iculture.core.folds')
-- vim.o.foldlevel = 99
-- vim.o.foldnestmax = 4
-- vim.o.foldminlines = 5
-- vim.o.foldlevelstart = 0
-- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
