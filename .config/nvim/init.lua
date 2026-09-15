-- Shared vim basics, then Neovim-only plugins and LSP on top.
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')
vim.cmd.source('~/.vimrc')

-- Reload files changed on disk (e.g. edited by Claude Code in another pane)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, { command = 'checktime' })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.airline_theme = 'lucius'
vim.g.airline_powerline_fonts = 1
if vim.env.LC_LIGHT_BG and vim.env.LC_LIGHT_BG ~= '' then
  vim.g.airline_theme = 'light'
end
if vim.fn.executable('rg') == 1 then
  vim.g.ackprg = 'rg --vimgrep'
end

require('lazy').setup({
  { 'junegunn/fzf', build = ':call fzf#install()' },
  'junegunn/fzf.vim',
  'tpope/vim-fugitive',
  'neovim/nvim-lspconfig',
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',
  'junegunn/goyo.vim',
  'mileszs/ack.vim',
  'preservim/nerdtree',
  'Xuyuanp/nerdtree-git-plugin',
  'HerringtonDarkholme/yats.vim',
  'hashivim/vim-terraform',
}, {
  change_detection = { notify = false },
  rocks = { enabled = false }, -- none of these plugins need luarocks
})

local map = vim.keymap.set
map('n', '<C-n>', ':NERDTreeToggle<CR>')
map('n', '<Leader>f', ':NERDTreeFind<CR>')
map('n', '<C-p>', ':GFiles<CR>')
map('n', '<Leader>a', ':Ack!<Space>')

require('lsp')
require('ask_claude')
