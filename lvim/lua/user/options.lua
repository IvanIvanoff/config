vim.opt.shiftwidth = 2        -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2           -- insert 2 spaces for a tab
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true           -- wrap lines
vim.opt.foldlevel = 99
vim.opt.autoclose_on = 0


-- Show trailing whitespaces
-- vim.opt.listchars = { eol = '↵' }
vim.opt.list = true

vim.opt.termguicolors = true


--
-- configure telescope so the results show the full path
-- it is very useful in the devops repo where I have exactly the
-- same file names in ./stage and ./prod directories, so I cannot
-- tell which file is being shown at all.
lvim.builtin.telescope.defaults.find_command = { "fd", "-t=f", "-a" }
lvim.builtin.telescope.defaults.path_display = { "absolute" }
