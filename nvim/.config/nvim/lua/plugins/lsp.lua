return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        -- C/C++
        clangd = {},
        
        -- Web Development
        vtsls = {},
        html = {},
        cssls = {},
        jsonls = {},
        
        -- Docker
        docker_compose = {},
        dockerfile = {},
        
        -- Go
        gopls = {},
        
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        
        -- CMake
        neocmakelsp = {},
        
        -- Rust
        rust_analyzer = {},
        
        -- Python (ty includes lsp + linting)
        ty = {},
        
        -- TOML
        taplo = {},
        
        -- Typst
        tinymist = {},
        
        -- YAML
        yamlls = {},
      },
    },
  },
}
