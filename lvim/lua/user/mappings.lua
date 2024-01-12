vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")

lvim.keys.normal_mode["<leader>f>"] = false

-- Remap some of the telescope mappings. As they start with <leader>
-- which_key needs to be used

lvim.keys.normal_mode["<leader>f"] = {}

lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  f = { "<cmd>Telescope find_files<CR>", "Find Files" },
  g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
  p = { "<cmd>Telescope projects<CR>", "Projects" },
  b = { "<cmd>Telescope buffers<CR>", "Buffers" },
  h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
  z = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Current Buffer Fuzzy Find" },
  n = { "<cmd>Navbuddy<CR>", "Navbuddy" },
}

lvim.keys.normal_mode["<leader>j"] = {}
lvim.builtin.which_key.mappings["j"] = {
  name = "Elixir helper mappings",
  r    = { "<cmd>Telescope lsp_references<CR>", "Find LSP References" },
  d    = { "<cmd>Telescope lsp_definitions<CR>", "Find LSP Definitions" }
}
