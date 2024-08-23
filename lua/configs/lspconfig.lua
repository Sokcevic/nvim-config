local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {  "html", "cssls", "dartls", "jdtls", "clangd", "pylsp", "ocamllsp", "java-debug-adapter"}
}

local lspconfig = require "lspconfig"

-- local servers = { "html", "cssls", "dartls", "jdtls", "clangd", "pylsp", "ocamllsp"}

-- lsps with default config
--for _, lsp in ipairs(servers) do
--  lspconfig[lsp].setup {
--    on_attach = on_attach,
--    on_init = on_init,
--    capabilities = capabilities,
--  }
--end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  --["rust_analyzer"] = function ()
  --    require("rust-tools").setup {}
  --end
  ["jdtls"] = function ()
  end,
  ["clangd"] = function ()
    require("lspconfig")["clangd"].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
      cmd = {
        "/home/lukassokcevic/.local/share/nvim/mason/bin/clangd",
        "--clang-tidy-checks=-*,cuda-*,-clang-diagnostic-cuda*"
      }
    }

  end
}
lspconfig["lua_ls"].setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}
