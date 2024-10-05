return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "bashls",
        "cssls",
        "dockerls",
        "elixirls",
        "emmet_ls",
        "eslint",
        "gopls",
        "graphql",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "rust_analyzer",
        "svelte",
        "ts_ls",
        "yamlls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "eslint_d",
        "gofumpt",
        "golangci-lint",
        "htmlhint",
        "jsonlint",
        "luacheck",
        "prettier",
        "ruff",
        "rustfmt",
        "shellcheck",
        "stylelint",
        "stylua",
        "trivy",
      },
    })
  end,
}
