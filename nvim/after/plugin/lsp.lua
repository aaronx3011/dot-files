-- 1. Ensure pyright is installed (you mentioned you have it, but double-check):
-- npm install pyright  (or pip install pyright)

-- 2. Set up nvim-lsp and pyright:
local lspconfig = require('lspconfig')

-- Add cmp_nvim_lsp capabilities settings to lspconfig (Important for nvim-cmp)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.pyright.setup {
    capabilities = capabilities,  -- Include capabilities for nvim-cmp
    -- Add any pyright settings here if needed (e.g., pythonVersion)
}

lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelProvider = false;
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
}

lspconfig.tsserver.setup {
    on_attach =  function(client, bufnr)
-- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
  end,
  filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
  cmd = {"typescript-language-server", "--stdio"}
}


-- 3. Autocommands for LSP actions (your existing code, slightly improved):
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        -- Use <localleader> for your keybindings (recommended):
        local map = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        local bufnr = event.buf
        -- Mappings.
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
        map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
        map({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
        map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        -- Buffer specific settings.
        vim.diagnostic.config({
            virtual_text = {
                prefix = '●', -- Change the virtual text prefix
            },
            float = {
                border = 'rounded'
            }
        }, bufnr)
    end,
})


-- 4.  Crucially: Set up nvim-cmp (if you haven't already):
local cmp = require 'cmp'
local luasnip = require 'luasnip'
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept selected completion item
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    }),
})

-- Optional: Configure diagnostics (warnings, errors, etc.)
vim.diagnostic.config({
    virtual_text = {
        prefix = '●', -- Change the virtual text prefix
    },
    float = {
        border = 'rounded'
    }
})
