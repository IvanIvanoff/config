-- vim options
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
vim.opt.shiftwidth = 2            -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2               -- insert 2 spaces for a tab
vim.opt.relativenumber = true     -- relative line numbers
vim.opt.wrap = true               -- wrap lines
vim.opt.foldlevel = 99

-- Show trailing whitespaces
-- vim.opt.listchars = { eol = '↵' }
vim.opt.list = true

vim.opt.termguicolors = true

-- add gt and gT to go to previous/next tab inside lvim
-- requires the bufferline plugin
lvim.keys.normal_mode["gt"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"] = ":BufferLineCyclePrev<CR>"

-- configure telescope find window file to be bigger
lvim.builtin.telescope.defaults.layout_config.width = 0.75
