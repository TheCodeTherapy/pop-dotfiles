" Set paths for python versions =======================================
let g:python_host_prog='/usr/bin/python2'
let g:python3_host_prog='/usr/bin/python3'
"======================================================================

" Defining tab thingie ================================================
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
" =====================================================================

set tags=./tags;

" Add line numbers ====================================================
set number
set relativenumber
"======================================================================

" Define chars for highlighting spaces and tabs =======================
set listchars=eol:⏎,tab:>· list
" set nolist
"======================================================================

" AutoInstall vim-plug ================================================
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
"======================================================================

" Plug thingies =======================================================
call plug#begin('~/.config/nvim/plugged')
" Functionalities =====================================================
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Powerline ===========================================================
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Snippets ============================================================
" Plug 'ncm2/ncm2-neosnippet'
" Text Editing ========================================================
Plug 'jiangmiao/auto-pairs'
Plug 'bronson/vim-trailing-whitespace'
" JavaScript stuff ====================================================
Plug 'othree/yajs.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'


" =====================================================================
call plug#end()
" =====================================================================

" General config ======================================================
set t_Co=256
syntax on
colorscheme gruvbox
set background=dark
highlight Comment gui=bold
" =====================================================================

" NERDTree config =====================================================
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'
" =====================================================================

" Powerline config ====================================================
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = "unique_tail"
" =====================================================================

" FZF config ==========================================================
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
" =====================================================================

" JavaScript config ===================================================
let g:jsx_ext_required = 1
" =====================================================================

" =====================================================================
" autocmd FileType javascript set formatprg=prettier\ --stdin
" =====================================================================

" Language Client configuration =======================================
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
            \ 'cpp': ['clangd'],
            \ }

nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>

" Key bindings ========================================================
let mapleader=","
" =====================================================================

nnoremap <leader>bb :buffers<cr>:b<space>
nnoremap <leader>bc :bd<cr>
nnoremap <leader><tab> :b#<cr>

imap <leader><leader> <esc>
imap <leader><leader>q <esc>:q!<CR>
imap <leader>w <esc>:w<CR>
imap <leader>wq <esc>:wq<CR>
" =====================================================================
nmap <leader>q :NERDTreeToggle<CR>
nmap \ <leader>q
nmap <silent> <leader><leader> :noh<CR>:q<CR>
" =====================================================================

" Automatic thingies ==================================================

" Auto-reload config on save ==========================================
if has ('autocmd') " Remain compatible with earlier versions
augroup vimrc      " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
    augroup END
endif " has autocmd
" =====================================================================

" Deoplete on start ===================================================
" let g:deoplete#enable_at_startup = 1
" =====================================================================

" =====================================================================
" Autocommands for file types
augroup filetypes
    autocmd!
    autocmd BufWinEnter,BufEnter *.md setlocal spell
    autocmd BufWinEnter,BufEnter *.md setf markdown
    autocmd BufNewFile,BufRead **/i3/config set filetype=i3config
    autocmd FileType c,cpp setlocal equalprg=clang-format
    autocmd BufWritePost *.c,*.cpp,*.h silent! !ctags -R &
augroup END
" =====================================================================

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
inoremap <leader>t <esc>:tabnext<CR>
nnoremap <leader>t :tabnext<CR>

"autocmd BufEnter * call ncm2#enable_for_buffer()
"set completeopt=noinsert,menuone,noselect
"set shortmess+=c
"
inoremap <c-c> <ESC>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
