local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()

require('nvim-ts-autotag').setup({
  filetypes = {
    'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx',
    'heex', 'ex', 'exs', 'eex',
    'rescript',
    'xml',
    'markdown',
    'astro', 'glimmer', 'handlebars', 'hbs' }
})

require("lvim.lsp.manager").setup("tailwindcss")
require("lvim.lsp.manager").setup("html")

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
  settings = {
    -- Otherwise I get "Cannot read property of null"
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
