reload("user.options")
reload("user.mappings")
reload("user.formatting")
reload("user.foldings")
reload("user.plugins")
reload("user.custom_filetype")
reload("user.custom_plugins_config")
reload("user.copilot_config")
reload("user.treesitter")
reload("user.telescope_config")

require("bufferline").setup()
require("breadcrumbs").setup()
require("textcase").setup {}
