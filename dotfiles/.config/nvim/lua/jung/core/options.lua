local opt = vim.opt -- for conciseness

-- line numbers
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 4 -- 2 spaces for indent width
opt.softtabstop = 4
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new line.

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if mixed case is performed in search, assumes case-sensitive

-- cursor line
opt.cursorline = true -- highlight current cursor line

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- turn off swapfile
opt.swapfile = false


-- Function to trim trailing whitespace
function TrimWhitespace()
  if vim.bo.filetype == 'markdown' then
    return
  end
  local save = vim.fn.winsaveview()
  vim.cmd('%s/\\s\\+$//e')
  vim.fn.winrestview(save)
end

-- Highlight trailing whitespace with red background
vim.cmd('highlight EOLWS ctermbg=red guibg=red')
vim.cmd('match EOLWS /\\s\\+$/')

-- Set up autocmd group for whitespace coloring
vim.api.nvim_create_augroup('whitespace_color', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'whitespace_color',
  pattern = '*',
  command = 'highlight EOLWS ctermbg=red guibg=red'
})
vim.api.nvim_create_autocmd('InsertEnter', {
  group = 'whitespace_color',
  pattern = '*',
  command = 'highlight EOLWS NONE'
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = 'whitespace_color',
  pattern = '*',
  command = 'highlight EOLWS ctermbg=red guibg=red'
})

-- Set up autocmd group for automatically trimming whitespace on save
vim.api.nvim_create_augroup('fix_whitespace_save', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'fix_whitespace_save',
  pattern = '*',
  callback = TrimWhitespace
})
