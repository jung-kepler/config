lua require('packages') -- ~/.config/nvim/packages.lua

function! s:packager_init(packager) abort
  " Packager
  call a:packager.add('https://github.com/kristijanhusak/vim-packager')

  " Language Server (LSP)
  call a:packager.add('https://github.com/neovim/nvim-lspconfig')
  call a:packager.add('https://github.com/hedyhli/outline.nvim')

  " Colorscheme
  call a:packager.add('https://github.com/bluz71/vim-nightfly-colors')

  " Nvim-Tree
  call a:packager.add('https://github.com/kyazdani42/nvim-tree.lua')
  call a:packager.add('https://github.com/kyazdani42/nvim-web-devicons')

  " Fuzzy Finder
  call a:packager.add('https://github.com/nvim-telescope/telescope.nvim')
  call a:packager.add('https://github.com/nvim-lua/plenary.nvim')

  " Tree Sitter
  " call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter')

  " Autocompletion
  call a:packager.add('https://github.com/hrsh7th/nvim-cmp')
  call a:packager.add('https://github.com/hrsh7th/cmp-nvim-lsp')
  call a:packager.add('https://github.com/hrsh7th/cmp-buffer')
  call a:packager.add('https://github.com/hrsh7th/cmp-path')
  call a:packager.add('https://github.com/hrsh7th/cmp-emoji')
  call a:packager.add('https://github.com/hrsh7th/vim-vsnip')
  call a:packager.add('https://github.com/hrsh7th/cmp-vsnip')

endfunction


call system(['git', 'clone', 'https://github.com/kristijanhusak/vim-packager', expand('~/.config/nvim/pack/packager/start/vim-packager')])

" Settings {{{
set number
set noswapfile
set cursorline

set ignorecase
set smartcase

colorscheme nightfly

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

set expandtab shiftwidth=2 softtabstop=2
" }}}

" Mappings {{{
let g:mapleader = ','

xnoremap <Leader>y "+y
nnoremap <Leader>y "+y

nnoremap <Space>11 1gt
nnoremap <Space>22 2gt
nnoremap <Space>33 3gt
nnoremap <Space>44 4gt
nnoremap <Space>55 5gt
nnoremap <Space>66 6gt
nnoremap <Space>77 7gt
nnoremap <Space>88 8gt
nnoremap <Space>99 <Cmd>tablast<CR>

nnoremap <C-]> <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <C-k> <Cmd>lua vim.lsp.buf.hover()<CR>
inoremap <C-s> <Cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <Leader>su <Cmd>lua vim.lsp.buf.references()<CR>
nnoremap <Leader>sr <Cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>sa <Cmd>lua vim.lsp.buf.code_action()<CR>
xnoremap <Leader>sa <Cmd>lua vim.lsp.buf.code_action()<CR>

" Nvim-tree
nnoremap <Leader>ee <Cmd>NvimTreeFindFileToggle<CR> 

" https://github.com/nvim-telescope/telescope.nvim
nnoremap <Leader>ff <Cmd>Telescope find_files hidden=true<CR>
nnoremap <Leader>fr <Cmd>Telescope oldfiles<CR>
nnoremap <Leader>fs <Cmd>Telescope live_grep<CR>
nnoremap <Leader>fc <Cmd>Telescope grep_string<CR>

" https://github.com/hrsh7th/vim-vsnip
imap <expr> <C-j> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<C-j>'
imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'

" https://github.com/hedyhli/outline.nvim
nnoremap <Space>oo <Cmd>Outline<CR>

"}}}


" Commands {{{
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! W w
command! Wa wa
command! WA wa
command! Wq wq
command! WQ wq
command! Wqa wqa
command! WQa wqa
command! WQA wqa

" https://github.com/hrsh7th/vim-vsnip
let g:vsnip_snippet_dir = expand('~/.config/nvim/snippets')
" }}}

augroup misc_custom
  autocmd VimEnter * call packager#setup(function('s:packager_init'), {'window_cmd': 'edit'})
augroup end
