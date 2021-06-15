local api = vim.api
local lspconfig = require('lspconfig')
local global = require('core.global')
local format = require('modules.lsp.format')

vim.cmd [[packadd lspsaga.nvim]]
local saga = require('lspsaga')
saga.init_lsp_saga()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

function _G.reload_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.cmd [[edit]]
end

function _G.open_lsp_log()
  local path = vim.lsp.get_log_path()
  vim.cmd("edit " .. path)
end

vim.cmd('command! -nargs=0 LspLog call v:lua.open_lsp_log()')
vim.cmd('command! -nargs=0 LspRestart call v:lua.reload_lsp()')

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = true,
    signs = {
      enable = true,
      priority = 20
    },
    -- Disable a feature
    update_in_insert = false,
})

local enhance_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    format.lsp_before_save()
  end
  api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

lspconfig.gopls.setup {
  cmd = {"gopls", "--remote=auto"},
  on_attach = enhance_attach,
  capabilities = capabilities,
  init_options = {
    usePlaceholders=true,
    completeUnimported=true,
  }
}

lspconfig.sumneko_lua.setup {
  on_attach = enhance_attach,
  capabilities = capabilities,
  cmd = {
    global.cache_dir.."sumneko_lua/lua-language-server/bin/macOS/lua-language-server",
    "-E",
    global.cache_dir.."sumneko_lua/lua-language-server/main.lua"
  };
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = {"vim","packer_plugins"}
      },
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ';')
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  }
}

-- required for "nvim-lsp-ts-utils"
require("null-ls").setup {}

lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
      enable_formatting = true,
    }
    -- required to enable ESLint code actions and formatting
    ts_utils.setup_client(client)

    -- disable tsserver formatting
    client.resolved_capabilities.document_formatting = false

    -- format on save
    vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
  end,
  capabilities = capabilities,
  init_options = {usePlaceholders = true}
}

lspconfig.clangd.setup {
  on_attach = enhance_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
}

local servers = {
  'dockerls','yamlls','jsonls','rust_analyzer','pyright'
}

for _,server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = enhance_attach,
    capabilities = capabilities
  }
end
