-- nvim-tree {{{
-- https://github.com/nvim-tree/nvim-tree.lua

require("nvim-tree").setup({
  disable_netrw = true,
  view = {
     width = 35,
     relativenumber = true
  },
  renderer = {
    full_name = true,
    symlink_destination = false,
    -- root_folder_label = false,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      }
    }
  },
  filters = {
    dotfiles = true,
    exclude = {
      "/dotfiles",
    },
  },
})
-- }}}

-- telescope {{{
-- https://github.com/nvim-telescope/telescope.nvim

require("telescope").setup({
  defaults = {
    path_display = { "truncate " },
    mappings = {
      i = {
        --["<esc>"] = actions.close,
        ["<C-u>"] = false,
      }
    },
  },
})
-- }}}

-- nvim-cmp {{{
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/cmp-nvim-lsp

local cmp = require("cmp")

local cmp_nvim_lsp = require("cmp_nvim_lsp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
    ["<C-j>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
    { name = "emoji" },
  }),
})

-- }}}

-- nvim-lspconfig {{{
-- https://github.com/neovim/nvim-lspconfig

local lspconfig = require("lspconfig")

---@diagnostic disable-next-line: undefined-field
local fs_stat = vim.loop.fs_stat

local default_on_attach = function(client)
  client.server_capabilities.semanticTokensProvider = nil
end

local getPythonPath = function()
  if vim.env.VIRTUAL_ENV == nil then
    return nil
  end
  return vim.env.VIRTUAL_ENV .. "/bin/python"
end

local language_servers = {
  bashls = {},
  cssls = {},
  dockerls = {},
  gopls = {},
  graphql = {},
  html = {},
  jsonls = {},
  ltex = {
    filetypes = {
      "bib",
      "gitcommit",
      "markdown",
      "markdown.mdx",
      "org",
      "pandoc",
      "plaintex",
      "quarto",
      "rmd",
      "rnoweb",
      "rst",
      "tex",
    },
    settings = {
      ltex = {
        language = "en-US",
        disabledRules = {
          ["en-US"] = {
            "ENGLISH_WORD_REPEAT_BEGINNING_RULE",
            "MORFOLOGIK_RULE_EN_US",
            "WHITESPACE_RULE",
          },
        },
      },
    },
  },
  lua_ls = {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if
        not fs_stat(path .. "/.luarc.json")
        and not fs_stat(path .. "/.luarc.jsonc")
      then
        client.config.settings =
          vim.tbl_deep_extend("force", client.config.settings, {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            },
          })
        client.notify(
          "workspace/didChangeConfiguration",
          { settings = client.config.settings }
        )
      end
      return true
    end,
  },
  mdx_analyzer = {},
  nginx_language_server = {},
  prismals = {},
  pyright = {
    settings = {
      python = {
        pythonPath = getPythonPath(),
      },
    },
  },
  r_language_server = {},
  rust_analyzer = {},
  svelte = {},
  taplo = {},
  terraformls = {},
  tsserver = {},
  vimls = {},
  yamlls = {
    filetypes = { "yaml" },
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/kubernetes/**",
          ["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "/*docker-compose.yml",
          ["https://raw.githubusercontent.com/threadheap/serverless-ide-vscode/master/packages/serverless-framework-schema/schema.json"] = "/*serverless.yml",
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/3.0.3/schemas/v3.0/schema.json"] = {
            "/*open-api*.yml",
            "/*open-api*.yaml",
          },
        },
      },
    },
  },
}
for server, server_config in pairs(language_servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    capabilities = default_capabilities,
    on_attach = default_on_attach,
  }, server_config))
end

-- }}}

-- outline.nvim {{{
-- https://github.com/hedyhli/outline.nvim

require("outline").setup()

-- }}}
