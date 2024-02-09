reload("user.options")
reload("user.mappings")
reload("user.formatting")
reload("user.foldings")
reload("user.plugins")
reload("user.custom_filetype")
reload("user.custom_plugins_config")
reload("user.copilot_config")


lvim.builtin.treesitter.ensure_installed =
{ "lua", "vim", "query", "javascript", "typescript", "elixir", "python", "css", "dockerfile", "graphql",
  "heex", "html", "json", "make", "markdown", "terraform", "yaml" }

require("bufferline").setup()
require("breadcrumbs").setup()
require("textcase").setup {}

lvim.builtin.treesitter.rainbow.enable = true
