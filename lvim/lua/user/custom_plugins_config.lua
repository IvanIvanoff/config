lvim.builtin.telescope.defaults.layout_config.width = 0.75

require('nvim-ts-autotag').setup({
  filetypes = {
    'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
    'heex', 'ex', 'exs', 'eex',
    'rescript',
    'xml',
    'php',
    'markdown',
    'astro', 'glimmer', 'handlebars', 'hbs' }
})

require("lvim.lsp.manager").setup("tailwindcss")

-- Otherwise in app.css I see a lot of errors for @apply
require("lvim.lsp.manager").setup("cssls", {
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore"
      }
    },
    scss = {
      validate = true,
      lint = {
        unknownAtRules = "ignore"
      }
    },
    less = {
      validate = true,
      lint = {
        unknownAtRules = "ignore"
      }
    },
  },
})

local lsp_flags = {
  debounce_text_changes = 150,
}


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- local lspconfig = require("lspconfig")

-- lspconfig.html.setup {
--   filetypes = { "html", "heex", "ex", "exs" }
-- }

-- lspconfig.tailwindcss.setup {
--   setup = {
--     tailwindcss = function(_, opts)
--       local tw = require("lspconfig.server_configurations.tailwindcss")
--       opts.filetypes = opts.filetypes or {}

--       -- Add default filetypes
--       vim.list_extend(opts.filetypes, tw.default_config.filetypes)

--       -- Remove excluded filetypes
--       --- @param ft string
--       opts.filetypes = vim.tbl_filter(function(ft)
--         return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
--       end, opts.filetypes)

--       -- Add additional filetypes
--       vim.list_extend(opts.filetypes, opts.filetypes_include or {})
--     end,
--   },
--   init_options = {
--     userlanguages = {
--       eelixir = "html-eex",
--       eruby = "erb",
--       elixir = "phoenix-heex",
--       heex = "phoenix-heex",
--       svelte = "html",
--     },
--   },
--   experimental = {
--     classRegex = {
--       [[class= "([^"]*)]],
--       [[class: "([^"]*)]],
--       '~H""".*class="([^"]*)".*"""',
--     },
--   },
--   -- handlers = {
--   --     ["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
--   --         vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id})
--   --     end,
--   --},
--   settings = {
--     tailwindCSS = {
--       lint = {
--         cssConflict = "warning",
--         invalidApply = "error",
--         invalidConfigPath = "error",
--         invalidScreen = "error",
--         invalidTailwindDirective = "error",
--         invalidVariant = "error",
--         recommendVariantOrder = "warning",
--       },
--     }
--   },
--   classAttributes = {
--     'class',
--     'className',
--     'classList',
--     'ngClass',
--   },
--   -- on_attach = on_attach,
--   flags = lsp_flags,
--   capabilities = capabilities,
-- }


local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  filetypes = { "html", "elixir", "eelixir", "heex" },
  init_options = {
    userLanguages = {
      elixir = "html-eex",
      eelixir = "html-eex",
      heex = "html-eex",
    },
  },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          'class[:]\\s*"([^"]*)"',
        },
      },
    },
  },
})

lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "html", "css", "elixir", "eelixir", "heex" },
})
