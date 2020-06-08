" Used for host detection
let hostname = substitute(system('hostname'), '\n', '', '')
let hostos   = substitute(system('uname -o'), '\n', '', '')
let hostkv   = substitute(system('uname -v'), '\n', '', '')

" Set up some paths that might be changed later based on the platform.  These
" are defaulted to their linux path
let g:dotfiles   = $HOME . '/dotfiles'
let g:env_folder = $HOME . '/.virtualenvs/default'

let g:dein_plugin = g:dotfiles . '/bundles/dein/repos/github.com/Shougo/dein.vim'
if isdirectory(g:dein_plugin)
   let g:dein_exists = 1
else
   let g:dein_exists = 0
endif

if has('nvim') && isdirectory(g:env_folder)
   let g:python_host_prog  = expand(g:env_folder . '/bin/python')
   let g:python3_host_prog = g:python_host_prog . '3'

   if empty(glob(g:python_host_prog))
      echom 'Could not find g:python_host_prog = '. g:python_host_prog
      let g:python_host_prog = trim(system('which python3'))
      echom 'Setting g:python_host_prog = '. g:python_host_prog
   endif
   if empty(glob(g:python3_host_prog))
      echom 'Could not find g:python3_host_prog = '. g:python3_host_prog
      let g:python3_host_prog = trim(system('which python3'))
      echom 'Setting g:python3_host_prog = '. g:python3_host_prog
   endif
endif


" Configure some unconventional filetypes
augroup filetypes
   " Ford
   au BufNewFile,BufRead *.fidl              setlocal ft=fidl
   au BufNewFile,BufRead */Config.in         setlocal ft=make

   au BufNewFile,BufRead Dockerfile*         setlocal ft=dockerfile
   au BufNewFile,BufRead */modulefiles/**    setlocal ft=tcl
augroup end

augroup whitespace
   autocmd!
   autocmd FileType cs              setlocal ff=dos
   autocmd FileType yaml,json       setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType cs,cpp,c,sh,ps1 setlocal ts=4 sw=4 sts=4 expandtab
   autocmd FileType tex             setlocal spell
   autocmd FileType xml             setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType make            setlocal ts=8 sw=8 sts=8 noet ai
   autocmd FileType fidl            setlocal ts=2 sw=2 sts=2 expandtab ai
   autocmd FileType gitcommit       setlocal ts=2 sw=2 sts=2 expandtab spell | syntax off
augroup END

set nocompatible  " Dein also wants this

" Enable true colour support:
if has('termguicolors')
  set termguicolors
endif

if g:dein_exists && (v:version >= 800 || has('nvim'))
   let &runtimepath.=',' . g:dein_plugin

   " Required:
   if dein#load_state(string(g:dotfiles . '/bundles/dein'))
      call dein#begin(g:dotfiles . '/bundles/dein')

      " Let dein manage dein
      call dein#add(g:dotfiles . '/bundles/dein/repos/github.com/Shougo/dein.vim')

      " Lazy-load on C++
      call dein#add('vim-scripts/DoxygenToolkit.vim', {'on_ft': ['c', 'cpp', 'h', 'hpp']})

      " fugitive - a Git wrapper for vim. Also allows current
      call dein#add('tpope/vim-fugitive')
      set diffopt+=vertical

      call dein#add('Valloric/YouCompleteMe',
         \ {
         \     'build': 'bash ./install.py --clang-completer --clang-tidy'
         \ },
      \ )
      call dein#add('rdnetto/YCM-Generator')

      call dein#add('SirVer/ultisnips')
      call dein#add('honza/vim-snippets')

      " Plugin to change the current directory to a project's root (so, look for
      " .git or something)
      call dein#add('airblade/vim-rooter')

      " Adding this so I can search/replace and preserve letter case
      call dein#add('tpope/vim-abolish')

      " Used for navigating the quickfix window better.  Recommended by fugitive
      call dein#add('tpope/vim-unimpaired')

      " This should improve Git Fugitive and Git Gutter
      call dein#add('tmux-plugins/vim-tmux-focus-events')

      " Plug to assist with commenting out blocks of text:
      call dein#add('tomtom/tcomment_vim')

      " Tabular, align equals
      call dein#add('godlygeek/tabular')

      " Show markers
      call dein#add('kshenoy/vim-signature')

      " " Status bar
      " call dein#add('powerline/powerline')

      call dein#add('rhysd/vim-clang-format')

      call dein#add('airblade/vim-gitgutter')

      " Display trailing whitespace
      call dein#add('ntpeters/vim-better-whitespace')

      if has('nvim')
         " Have vim reload a file if it has changed outside of vim:
         call dein#add('TheZoq2/neovim-auto-autoread')

         call dein#add('vimlab/split-term.vim')

         " ccls
         call dein#add('autozimu/LanguageClient-neovim',
             \ {
             \   'rev': 'next',
             \   'build': 'bash install.sh',
             \ }
         \ )
      endif

      " Install fzf, the fuzzy searcher (also loads Ultisnips)
      call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
      call dein#add('junegunn/fzf.vim', {'depends': 'fzf' })

      "
      " Colourschemes
      call dein#add('altercation/vim-colors-solarized')
      call dein#add('kristijanhusak/vim-hybrid-material')
      call dein#add('atelierbram/vim-colors_duotones')
      call dein#add('atelierbram/vim-colors_atelier-schemes')

      " Other..
      call dein#add('joshdick/onedark.vim')
      call dein#add('arcticicestudio/nord-vim')
      call dein#add('drewtempelmeyer/palenight.vim')
      call dein#add('morhetz/gruvbox')
      call dein#add('mhartington/oceanic-next')

      call dein#add('ayu-theme/ayu-vim')
      let ayucolor="mirage"

      " A bunch more...
      call dein#add('flazz/vim-colorschemes')

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

colo flatland

""""""""""""""""""""" Git-Gutter """"""""""""""""""""""""
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage the hunk with <Leader>hs or
" revert it with <Leader>hr.
""""""""""""""""""""" /Git-Gutter """"""""""""""""""""""""


""""""""""""""""""" vim-clang-format """""""""""""""""""""
" Detect clang-format file
let g:clang_format#detect_style_file = 1

" Key mappings for clang-format, to format source code:
if has('unix')
   autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>fo :pyf /usr/share/clang/clang-format-10/clang-format.py<CR>
   autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
   autocmd FileType c,cpp,h,hpp vnoremap <buffer><Leader>f :ClangFormat<CR>
   autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

   " map <leader>f :pyf /usr/share/clang/clang-format.py<CR>

   nmap <Leader>C :ClangFormatAutoToggle<CR>
endif

" Have vim reload a file if it has changed outside
" of vim:
if !has('nvim')
   set autoread
endif

if has('unix')
   " Tell vim to look for a tags file in the current
   " directory, and all the way up until it finds one:
   set tags=./tags;/
endif

""""""""""""""""""""""" YCM Config """"""""""""""""""""""""
silent if g:dein_exists && dein#check_install('YouCompleteMe') == 0
   " Let YouCompleteMe use tag files for completion as well:
   let g:ycm_collect_identifiers_from_tags_files = 1

   " Turn off prompting to load .ycm_extra_conf.py:
   let g:ycm_confirm_extra_conf = 0

   " Compile the file
   nnoremap <leader>y :YcmDiag<CR>

   " Ignore some files
   let g:ycm_filetype_blacklist = {
      \ 'tagbar'    : 1,
      \ 'qf'        : 1,
      \ 'notes'     : 1,
      \ 'markdown'  : 1,
      \ 'unite'     : 1,
      \ 'text'      : 1,
      \ 'vimwiki'   : 1,
      \ 'pandoc'    : 1,
      \ 'infolog'   : 1,
      \ 'vim'       : 1,
      \ 'gitcommit' : 1,
      \ 'gitrebase' : 1,
      \ 'cmake'     : 1,
      \ 'mail'      : 1,
      \ 'frag'      : 1,
      \ 'vert'      : 1,
      \ 'comp'      : 1,
      \ 'qml'       : 1,
      \ 'tex'       : 1,
      \ 'lcm'       : 1
   \}

   let g:ycm_filetype_whitelist = {
      \ 'javascript': 1,
      \ 'python'    : 1,
      \ 'css'       : 1,
      \ 'cpp'       : 1,
      \ 'cs'        : 1,
      \ 'php'       : 1,
      \ 'fortran'   : 1,
      \ 'xml'       : 1,
      \ 'html'      : 1
   \}

   " Ignore large files (BONA db's for instance)
   let g:ycm_disable_for_files_larger_than_kb = 300

   " Shut off preview window on PHP files
   au BufNewFile,BufRead *.php let g:ycm_add_preview_to_completeopt=0

   if exists('g:python_host_prog')
      let g:interpreter_path = g:python_host_prog
   endif

   map <F9> :YcmCompleter FixIt<CR>
endif
"""""""""""""""""""""" /YCM Config """"""""""""""""""""""""


""""""""""""""""" LanguageClient Config """""""""""""""""""
if !exists('g:gui_oni')
   let g:LanguageClient_serverCommands = {
      \ 'cpp': [
         \ 'ccls',
         \ '--log-file=/tmp/cq.log',
         \ '-v=1'
      \ ]
   \ }
   let g:LanguageClient_loadSettings = 1
   let g:LanguageClient_settingsPath = g:dotfiles . '/ccls_settings.json'
   " Limits how often the LanguageClient talks to the
   " server, so it reduces CPU load and flashing.
   let g:LanguageClient_changeThrottle = 0.5
   let g:LanguageClient_diagnosticsEnable = 0
   nnoremap <leader>ty :call LanguageClient#textDocument_hover()<CR>
   nnoremap <leader>rf :call LanguageClient#textDocument_references()<CR>
   nnoremap <leader>rj :call LanguageClient#textDocument_definition()<CR>
   nnoremap <leader>rT :call LanguageClient#textDocument_definition({'gotoCmd': 'tabe'})<CR>
   nnoremap <leader>rS :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
   nnoremap <leader>rX :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
   nnoremap <leader>rV :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
   nnoremap <leader>rw :call LanguageClient#textDocument_rename()<CR>
endif
""""""""""""""""" /LanguageClient Config """"""""""""""""""

"""""""""""""""""""" Ultisnips config """"""""""""""""""""""
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
silent if g:dein_exists && dein#check_install('ultisnips') == 0
   let g:UltiSnipsExpandTrigger='<c-j>'
   let g:UltiSnipsJumpForwardTrigger='<c-j>'
   let g:UltiSnipsJumpBackwardTrigger='<c-n>'

   " If you want :UltiSnipsEdit to split your window.
   let g:UltiSnipsEditSplit='vertical'

   " Add to the runtime path so that custom
   " snippets can be found:
   set rtp+=g:dotfiles
endif
""""""""""""""""""" /Ultisnips config """"""""""""""""""""""


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


""""""""""""""""""""" Generate UUID """"""""""""""""""""""""
if has('unix')
   silent! py import uuid
   noremap <leader>u :s/REPLACE_UUID/\=pyeval('str(uuid.uuid4())')/g
   noremap <leader>ru :%s/REPLACE_UUID/\=pyeval('str(uuid.uuid4())')/g
endif
"""""""""""""""""""" /Generate UUID """"""""""""""""""""""""

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
