local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    "editorconfig/editorconfig-vim",
    "maxmx03/solarized.nvim",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "dense-analysis/ale",
})

vim.o.compatible = false
vim.o.title = true
vim.o.background = "dark"
vim.o.autoindent = true
vim.o.backup = false

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 0

vim.o.showmatch = true
vim.o.showcmd = true
vim.cmd("syntax enable")

vim.o.textwidth = 74
vim.o.visualbell = true
vim.o.ruler = true
vim.o.backspace = "indent,eol,start"

vim.o.viminfo = "'100,f1"

vim.o.wildmenu = true
vim.o.wildmode = "list:longest,full"

vim.opt.spell = true
vim.opt.spelllang = "en_us"

vim.o.laststatus = 2

