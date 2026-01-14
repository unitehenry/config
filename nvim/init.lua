require("config.lazy")

vim.cmd("syntax on")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set expandtab")
vim.cmd("set ai")
vim.cmd("set number")
vim.cmd("set incsearch")
vim.cmd("set wildmenu")
vim.cmd("set ruler")
vim.cmd("set list")
vim.cmd("set cursorline")
vim.cmd("set colorcolumn=0")
vim.cmd("set re=0")
vim.cmd("set backspace=indent,eol,start")
vim.cmd("set guicursor=n-v-c-i:block")
vim.opt.listchars = { eol = '$' }

vim.keymap.set({'n', 'v'}, '<localleader>m', function()
  local s_start = vim.fn.getpos "."
  local s_end = vim.fn.getpos "v"
  local lines = vim.fn.getregion(s_start,s_end)
  local content = table.concat(lines, " ")
  vim.system({'opencode', 'run', content })
end)
