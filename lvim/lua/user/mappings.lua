-- Make jk and jj work as <Esc> in insert mode
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "jj", "<Esc>")

-- break line at the cursor
-- vim.keymap.set("n", "br", "i<CR><Esc>")


-- restore the session for the current directory
vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})
-- restore the last session
vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})
-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})

lvim.keys.normal_mode["<leader>q"] = false
lvim.keys.normal_mode["<leader>q"] = {}
lvim.builtin.which_key.mappings["q"] = {
  name = "Persistence",
  s = { "<cmd>lua require(\"persistence\").load()<CR>", "Restore session for current directory" },
  l = { "<cmd>lua require(\"persistence\").load({ last = true })<CR>", "Restore last session" },
  d = { "<cmd>lua require(\"persistence\").stop()<CR>", "Do not save session on exit" }
}

-- Remap some of the telescope mappings. As they start with <leader>
-- which_key needs to be used
lvim.keys.normal_mode["<leader>f>"] = false
lvim.keys.normal_mode["<leader>f"] = {}

lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  f = { "<cmd>Telescope git_files<CR>", "Git Files" },
  t = { "<cmd>Telescope find_files<CR>", "Find Files" },
  g = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
  v = { "<cmd>Telescope grep_string<CR>", "Grep String under cursor or visual selection" },
  p = { "<cmd>Telescope projects<CR>", "Projects" },
  b = { "<cmd>Telescope buffers<CR>", "Buffers" },
  h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
  z = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Current Buffer Fuzzy Find" },
  n = { "<cmd>Navbuddy<CR>", "Navbuddy" },
}

-- Search and Replace
lvim.keys.normal_mode["<leader>S"] = false
lvim.keys.normal_mode["<leader>S"] = {}

lvim.builtin.which_key.mappings["S"] = {
  name = "Spectre Search & Replace",
  S = { "<cmd>lua require('spectre').toggle()<CR>", "Toggle Spectre" },
  w = { "<cmd> lua require('spectre').open_visual({select_word=true})<CR>", "Search Current Word" },
  v = { "<cmd> lua require('spectre').open_visual()<CR>", "Search Visual Selection" },
  n = { "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", "Search On Current File" }
}
lvim.keys.normal_mode["<leader>j"] = {}
lvim.builtin.which_key.mappings["j"] = {
  name = "Elixir helper mappings",
  r    = { "<cmd>Telescope lsp_references<CR>", "Find LSP References" },
  d    = { "<cmd>Telescope lsp_definitions<CR>", "Find LSP Definitions" }
}
