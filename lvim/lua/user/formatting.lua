-- formatting
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.lua", "*.py", "*.ex", "*.exs", "*.heex", "*.js", "*.json", "*.html" }

-- colorize
lvim.builtin.cmp.formatting = {
  format = require("tailwindcss-colorizer-cmp").formatter
}
