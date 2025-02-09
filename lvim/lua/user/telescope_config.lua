-- conffind window file to be bigger
lvim.builtin.telescope.defaults.layout_config.width = 0.75

lvim.builtin.telescope.defaults = ({
  find_command = { "fd", "-t=f", "-a" },
  path_display = { "absolute" },
  wrap_results = true,
})

lvim.builtin.telescope.pickers.find_files = {
  layout_strategy = "center",
  layout_config = { width = 0.99, height = 0.99, preview_width = nil, prompt_position = "top" }
}

lvim.builtin.telescope.pickers.live_grep = {
  layout_config = { height = 0.99, width = 0.99, preview_cutoff = 120, preview_width = 0.6, prompt_position = "top" },
  layout_strategy = "horizontal"
}

lvim.builtin.telescope.pickers.git_commits = {
  layout_strategy = "horizontal",
  layout_config = { height = 0.88, width = 0.88, preview_cutoff = 20, preview_width = 0.70, prompt_position = "bottom" }
}

lvim.builtin.telescope.pickers.man_pages = {
  layout_strategy = "horizontal",
  layout_config = { height = 0.99, width = 0.99, preview_cutoff = nil, preview_width = 0.80, prompt_position = "bottom" }
}

lvim.builtin.telescope.pickers.vim_options = { layout_config = { height = 0.66, width = 0.66 } }

lvim.builtin.telescope.pickers.colorscheme = { layout_strategy = "cursor", layout_config = { width = 0.19 } }
