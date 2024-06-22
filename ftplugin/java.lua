local home = os.getenv "HOME"
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

local ok_mason, mason_registry = pcall(require, "mason-registry")
if not ok_mason then
    vim.notify("mason-registry could not be loaded")
    return
end

local java_test_path = mason_registry.get_package("java-test"):get_install_path()
local java_debug_adapter_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))
vim.list_extend(
    bundles,
    vim.split(vim.fn.glob(java_debug_adapter_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
)

local config = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
    "-data",
    workspace_dir,
  },
  root_dir = require("lspconfig").util.root_pattern(
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts"
  )(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())),

  settings = {
    java = {
      configuration = {
        runtimes = {
          name = "JavaSE-21",
          path = "/usr/lib/jvm/openjdk-21.0.2/",
          javadoc = "https://docs.oracle.com/en/java/javase/21/docs/api/",
          default = true,
        },
      },
      signatureHelp = { enabled = true },
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      extendedClientCapabilities = extendedClientCapabilities,
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "none", -- literals, all, none
        },
      },
      format = {
        enabled = true,
      },
    },
  },

  init_options = {
    bundles = bundles,
  },
}

require('jdtls').setup_dap({ hotcodereplace = 'auto' })
require("jdtls").start_or_attach(config)
