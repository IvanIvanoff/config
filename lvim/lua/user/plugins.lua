lvim.plugins = {
  {
    "neovim/nvim-lspconfig",
    -- Failed to run `config` for
    -- nvim-navbuddy ...e/pack/lazy/opt/nvim-navbuddy/lua/nvim-navbuddy/init.lua:419: attempt to call field 'get_clients' (a nil value)
    -- dependencies = {
    --   {
    --     -- Remapped to <leader>fn, which opens the navbuddy window.
    --     -- The icons are listed as there were missing intervals after some icons
    --     "SmiteshP/nvim-navbuddy",
    --     dependencies = {
    --       "SmiteshP/nvim-navic",
    --       "MunifTanjim/nui.nvim"
    --     },
    --     opts = {
    --       lsp = { auto_attach = true },
    --       icons = {
    --         File          = "󰈙 ",
    --         Module        = " ",
    --         Namespace     = "󰌗 ",
    --         Package       = " ",
    --         Class         = "󰌗 ",
    --         Method        = "󰆧 ",
    --         Property      = " ",
    --         Field         = " ",
    --         Constructor   = " ",
    --         Enum          = "󰉻 ",
    --         Interface     = "󰕘 ",
    --         Function      = "󰊕 ",
    --         Variable      = "󰫧 ",
    --         Constant      = "󰏿 ",
    --         String        = " ",
    --         Number        = "󰎠 ",
    --         Boolean       = "󰊾 ",
    --         Array         = "󰅪 ",
    --         Object        = "󰅩 ",
    --         Key           = "󰌋 ",
    --         Null          = "󰟢 ",
    --         EnumMember    = " ",
    --         Struct        = "󰌗 ",
    --         Event         = " ",
    --         Operator      = "󰆕 ",
    --         TypeParameter = "󰊄 ",
    --       },

    --     }
    --   }
    -- },
    servers = {
      tailwindcss = {
        filetypes_include = { "ex", "exs", "heex" }
      }
    },
  },
  -- {
  --   "romgrk/nvim-treesitter-context",
  --   config = function()
  --     require("treesitter-context").setup {
  --       enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
  --       throttle = true, -- Throttles plugin updates (may improve performance)
  --       max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
  --       patterns = {     -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
  --         default = {
  --           'class',
  --           'function',
  --           'method',
  --         },
  --         elixir = {
  --           "anonymous_function",
  --           "arguments",
  --           "block",
  --           "do_block",
  --           "list",
  --           "map",
  --           "tuple",
  --           "quoted_content",
  --         }
  --       },
  --     }
  --   end
  -- },
  {
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end
  },
  -- {
  --   -- autoclose and autorename html tag
  --   "windwp/nvim-ts-autotag",
  --   config = function()
  --     require("nvim-ts-autotag").setup()
  --   end,
  -- },
  -- {
  --   -- better % jumps
  --   "andymass/vim-matchup",
  --   setup = function()
  --     vim.g.matchup_matchparen_offscreen = { method = "popup" }
  --   end,
  -- },
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
  {
    -- better search and replace
    -- On MacOS first run: brew install gnu-sed
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    -- Select some text in visual mode and use the Subs/text/newtext/ command
    -- to replace, preserving the case
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    -- ys{motion}{bracket,quotes,etc}.
    -- ds{motion}{bracket,quotes,etc}.
    -- ys{motion}f - suround with a function
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    "LunarVim/breadcrumbs.nvim",
    dependencies = {
      { "SmiteshP/nvim-navic" },
    },
  },
  -- {
  --   "tpope/vim-fugitive",
  --   cmd = {
  --     "G",
  --     "Git",
  --     "Gdiffsplit",
  --     "Gread",
  --     "Gwrite",
  --     "Ggrep",
  --     "GMove",
  --     "GDelete",
  --     "GBrowse",
  --     "GRemove",
  --     "GRename",
  --     "Glgrep",
  --     "Gedit"
  --   },
  --   ft = { "fugitive" }
  -- },
  {
    -- Remapped to <leader>ql to load last session
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    }
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  {
    -- improve the Ctrl+E/U/Y/D/etc. scrolling
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup {}
    end
  },
  -- {
  --   "folke/trouble.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   }
  -- },
  -- {
  --   -- peek the line when using :{number} before hitting enter
  --   "nacro90/numb.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("numb").setup {
  --       show_numbers = true,    -- Enable 'number' for the window while peeking
  --       show_cursorline = true, -- Enable 'cursorline' for the window while peeking
  --     }
  --   end,
  -- },
  -- {
  --   'wfxr/minimap.vim',
  --   build = "cargo install --locked code-minimap",
  --   -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
  --   config = function()
  --     vim.cmd("let g:minimap_width = 10")
  --     vim.cmd("let g:minimap_auto_start = 1")
  --     vim.cmd("let g:minimap_auto_start_win_enter = 1")
  --   end,
  -- },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },
  {
    -- press s or S in normal mode and type the first to characters of the word
    -- you want to jump to.
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    -- gd, gr, gf are used to go to definition, references and files
    -- This plugins adds gpd, gpr, gpi, etc. to preview the definition/reference/etc.
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120,             -- Width of the floating window
        height = 25,             -- Height of the floating window
        default_mappings = true, -- Bind default mappings
        debug = false,           -- Print debug information
        opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil     -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end
  },
  -- {
  --   -- color schemes
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000
  -- },
  {
    -- rainbow parentheses
    "HiPhish/rainbow-delimiters.nvim",
  },
  -- {
  --   -- hint when you type
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function() require "lsp_signature".on_attach() end,
  -- },
  -- {
  --   -- open a url with gx
  --   "felipec/vim-sanegx",
  --   event = "BufRead",
  -- },
}
