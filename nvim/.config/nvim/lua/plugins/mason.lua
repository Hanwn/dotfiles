return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP Servers
        "clangd",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "neocmakelsp",
        "ty",
        "ruff",
        "rust-analyzer",
        "taplo",
        "tinymist",
        "vtsls",
        "yaml-language-server",
        
        -- Formatters
        "gofumpt",
        "goimports",
        "oxlint",
        "prettier",
        "prettypst",
        "shfmt",
        "stylua",
        "yamlfmt",
        
        -- DAP
        "codelldb",
      },
    },
  },
}
