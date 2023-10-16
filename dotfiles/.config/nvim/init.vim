colorscheme desert
set number

if &compatible
  set nocompatible
endif

function! PackagerInit() abort
  packadd vim-packager
  call packager#init({'depth': 1})
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call packager#add('nvim-lua/plenary.nvim')
  call packager#add('nvim-telescope/telescope.nvim', { 'tag': '0.1.4' })
endfunction

command! PlugInstall call PackagerInit() |
      \ call packager#install()
command! -bang PlugUpdate call PackagerInit() |
      \ call packager#update({'force_hooks': '<bang>'})
command! -bang PlugClean call PackagerInit() |
      \ call packager#clean()
command! -bang PlugStatus call PackagerInit() |
      \ call packager#status()

nnoremap <silent><C-p> <cmd>Telescope find_files<cr>
nnoremap <silent><C-_> <cmd>Telescope live_grep<cr>
nnoremap <silent><C-q> <ESC>
