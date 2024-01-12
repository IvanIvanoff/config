reload("user.options")
reload("user.formatting")
reload("user.foldings")
reload("user.plugins")
reload("user.copilot_config")

lvim.builtin.treesitter.ensure_installed = { "elixir", "heex" }

vim.opt.termguicolors = true
require("bufferline").setup()

reload("user.mappings")
