local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- require('nvim-ts-autotag').setup({
--   filetypes = {
--     'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
--     'heex', 'ex', 'exs', 'eex',
--     'rescript',
--     'xml',
--     'markdown',
--     'astro', 'glimmer', 'handlebars', 'hbs' }
-- })

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

lspconfig.html.setup {
  capabilities = capabilities,
  provideFormatter = true,
  settings = {
    css = {
      lint = {
        validProperties = {},
      },
    },
    html = {
      lint = {
        validProperties = {}
      },
    }
  },
}

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

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

-- @type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  priority = {
    [''] = 110,
    lua = 210,
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}
