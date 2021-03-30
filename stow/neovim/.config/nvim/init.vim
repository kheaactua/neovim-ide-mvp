" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')
let hostos   = substitute(system('uname -o'), '\n', '', '')
let hostkv   = substitute(system('uname -v'), '\n', '', '')

" Set up some paths that might be changed later based on the platform.  These
" are defaulted to their linux path
let g:bundles    = $HOME . '/bundles'
let g:env_folder = $HOME . '/.virtualenvs/default'

let g:dein_plugin = g:bundles . '/dein/repos/github.com/Shougo/dein.vim'
if isdirectory(g:dein_plugin)
   let g:dein_exists = 1
else
   let g:dein_exists = 0
endif

" Configure some unconventional filetypes
augroup filetypes
   " Ford
   au BufNewFile,BufRead *.te                setlocal ft=sh
   au BufNewFile,BufRead *.fs                setlocal ft=sh
   au BufNewFile,BufRead */aos/*.rc          setlocal ft=sh
   au BufNewFile,BufRead file_contexts       setlocal ft=sh
augroup end

augroup whitespace
   autocmd!
   autocmd FileType yaml,json       setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType tex             setlocal spell
   autocmd FileType xml             setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType cmake           setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType make            setlocal ts=8 sw=8 sts=8 noet ai
   autocmd FileType fidl            setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType aidl            setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType gitcommit       setlocal ts=2 sw=2 sts=2 expandtab spell | syntax off
   autocmd FileType groovy          setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType lua             setlocal ts=2 sw=2 sts=2 expandtab
   autocmd FileType cs,cpp,c,sh,ps1,kotlin,java setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType bzl,javascript  setlocal ts=4 sw=4 sts=4 expandtab
augroup END

set nocompatible  " Dein also wants this

" Enable true colour support:
if has('termguicolors')
  set termguicolors
endif

if g:dein_exists
   let &runtimepath.=',' . g:dein_plugin

   " Required:
   if dein#load_state(string(g:bundles . '/dein'))
      call dein#begin(g:bundles . '/dein')

      " Let dein manage dein
      call dein#add(g:bundles . '/dein/repos/github.com/Shougo/dein.vim')

      " Lazy-load on C++
      call dein#add('vim-scripts/DoxygenToolkit.vim', {'on_ft': ['c', 'cpp', 'h', 'hpp']})

      " fugitive - a Git wrapper for vim. Also allows current
      call dein#add('tpope/vim-fugitive')
      set diffopt+=vertical

      call dein#add('SirVer/ultisnips')
      call dein#add('honza/vim-snippets')

      " Plugin to change the current directory to a project's root (so, look for
      " .git or something)
      call dein#add('airblade/vim-rooter')

      " Adding this so I can search/replace and preserve letter case
      call dein#add('tpope/vim-abolish')

      " Used for navigating the quickfix window better.  Recommended by fugitive
      call dein#add('tpope/vim-unimpaired')

      " Plug to assist with commenting out blocks of text:
      call dein#add('tomtom/tcomment_vim')

      " Tabular, align equals
      call dein#add('godlygeek/tabular')

      " Show markers
      call dein#add('kshenoy/vim-signature')

      call dein#add('airblade/vim-gitgutter')

      " Display trailing whitespace
      call dein#add('ntpeters/vim-better-whitespace')

      " Have vim reload a file if it has changed outside of vim:
      call dein#add('TheZoq2/neovim-auto-autoread')


      call dein#add('neovim/nvim-lspconfig')
      call dein#add('hrsh7th/nvim-compe') " Autocompletion plugin

      " Install fzf, the fuzzy searcher (also loads Ultisnips)
      call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
      call dein#add('junegunn/fzf.vim', {'depends': 'fzf' })

      " Syntax highlighting for kotlin
      call dein#add('udalov/kotlin-vim')

      call dein#add('kheaactua/vim-fzf-repo')

      "
      " Colourschemes
      call dein#add('arcticicestudio/nord-vim')

      "
      " /Colourschemes

     " Required:
     call dein#end() " On Windows, outputting No matching autocommands"
     call dein#save_state()
   endif

   " Required:
   filetype plugin indent on
   syntax enable

   " If you want to install not installed plugins on startup.
   if dein#check_install()
      call dein#install()
   endif

   "End dein Scripts-------------------------
endif

colo nord

""""""""""""""""""""" Git-Gutter """"""""""""""""""""""""
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage the hunk with <Leader>hs or
" revert it with <Leader>hr.
""""""""""""""""""""" /Git-Gutter """"""""""""""""""""""""

"""""""""""""""""""""" LSP """"""""""""""""""""""""

" Set up the built-in language client
lua <<EOF
local lspconfig = require'lspconfig'
-- We check if a language server is available before setting it up.
-- Otherwise, we'll get errors when loading files.

-- Set up clangd
lspconfig.clangd.setup{
  cmd = { "clangd", "--background-index" }
}

if 1 == vim.fn.executable("cmake-language-server") then
  lspconfig.cmake.setup{}
end

if 1 == vim.fn.executable("kotlin-language-server") then
   require'lspconfig'.kotlin_language_server.setup{}
end

if 1 == vim.fn.executable("pyls") then
  lspconfig.pyls.setup{}
end

-- Configure the way code diagnostics are displayed
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

EOF

augroup lsp
   autocmd!
   autocmd Filetype c setlocal omnifunc=v:lua.vim.lsp.omnifunc
   autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
   autocmd Filetype cpp lua require('compe_config')
   autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
augroup end

nnoremap <silent> <leader>rd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>rj <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>ty <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>rk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rf <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>rw <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>c  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>m  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" Various mappings to open the corresponding header/source file in a new split
nnoremap <silent> <leader>of <cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oh <cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oj <cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ok <cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ol <cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>

nnoremap <silent> [z         <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]z         <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
"""""""""""""""""""""" /LSP """"""""""""""""""""""""


if has('nvim-0.5')
   augroup lsp
     autocmd!
     autocmd Filetype c setlocal omnifunc=v:lua.vim.lsp.omnifunc
     autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc
     autocmd Filetype cpp lua require('compe_config')
     autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
   augroup end
endif

nnoremap <silent> <leader>rd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>rj <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>ty <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>rk <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>rf <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ds <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>rw <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>c  <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>m  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" Various mappings to open the corresponding header/source file in a new split
nnoremap <silent> <leader>of <cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oh <cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>oj <cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ok <cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>
nnoremap <silent> <leader>ol <cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>

nnoremap <silent> [z         <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]z         <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
"""""""""""""""""""""" /LSP """"""""""""""""""""""""

"""""""""""""""""""" rooter config """"""""""""""""""""""
" Stop printing the cwd on write
let rooter_silent_chdir=1
""""""""""""""""""" /rooter config """"""""""""""""""""""

"""""""""""""""""""""""""" fzf """""""""""""""""""""""""""
silent if has('unix') && g:dein_exists && dein#check_install('fzf') == 0
   " Set up keyboard shortbuts for fzf, the fuzzy finder
   " This one searches all the files in the current git repo:
   noremap <c-k> :GitFiles<CR>
   noremap <leader><Tab> :Buffers<CR>
   noremap <c-j> :Files<CR>
   noremap gsiw :GGrepIW<cr>
   noremap <leader>s :Snippets<cr>
   noremap <leader>c :Colors<cr>

   " Unmap center/<CR> from launching fzf which appears to be mapped by default.
   " unmap <CR>

   let g:search_tool='rg'
   if g:search_tool ==? 'rg'
      noremap <leader>g :Rg<cr>
      command! -nargs=* -bang GGrepIW
         \ call fzf#vim#grep(
         \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(expand('<cword>')), 1,
         \   fzf#vim#with_preview(), <bang>0)
   else
      noremap <leader>g :Ag<cr>
      command! -nargs=* -bang GGrepIW
        \ call fzf#vim#grep(
        \    'ag --nogroup --column --color -s '.shellescape(expand('<cword>')), 1,
        \    fzf#vim#with_preview(), <bang>0)
   endif
endif
""""""""""""""""""""""""" /fzf """""""""""""""""""""""""""

filetype on
syntax on
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
set number
set ignorecase
set noincsearch
set hlsearch

" Remove trailing space
nnoremap <leader>rt :silent! %s/\s\+$//e<CR>
let @r='\rt'
let @t=':try|silent! exe "norm! @r"|endtry|w|n'
let trim_whitelist = ['php', 'js', 'cpp', 'h', 'vim', 'css']
autocmd BufWritePre * if index(trim_whitelist, &ft) >= 0 | :%s/\s\+$//e

" Ignore whitespace on vimdiff
if &diff
   " diff mode
   set diffopt+=iwhite
endif

" Faster vertical expansion
nmap <C-v> :vertical resize +5<cr>
nmap <C-b> :above resize +5<cr>

" Swap splits to vertical
noremap <C-w>th <C-W>t<c-w>H
noremap <C-w>tv <C-W>t<c-w>K

" Remove search results
noremap H :noh<cr>

" Replace highlighted content with content of register 0
noremap <C-p> ciw<Esc>"0p

" Un-indent current line by one tab stop
imap <S-Tab> <C-o><<

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" Auto-correct spelling mistakes
" source: https://castel.dev/post/lecture-notes-1/
set spelllang=en_gb,en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Map // to search for highlighted text. Source http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/<C-R>"<CR>

" Match <> brackets
set matchpairs+=<:>

" try to automatically fold xml
let xml_syntax_folding=1

" Without this, mouse wheel in vim/tmux scrolls tmux history, not vim's buffer
set mouse=a

"
" Abbreviations.  Check https://github.com/tpope/vim-abolish for how to make
" these case insensitive (if I need it)
ab flaot float
ab boid void
ab laster laser
ab jsut just
ab eticket etiket
ab breif brief
ab OPL2 OPAL2
ab unqiue unique
ab unique unique
ab AdditionaInputs AdditionalInputs
ab cosnt const
ab horizonal horizontal
ab appraoch approach
ab yeild yield
ab lsit list

" vim: ts=3 sts=3 sw=3 expandtab nowrap ff=unix :
