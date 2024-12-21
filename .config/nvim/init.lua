-- =====================================
-- Neovim Configuration - init.lua
-- =====================================

-- ------------------------------
-- 1. Leader Key Setup
-- ------------------------------
-- Set leader key to space and disable its default mapping
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<Space>', '<NOP>', { noremap = true, silent = true })

-- ------------------------------
-- 2. Basic Settings
-- ------------------------------
local opt = vim.opt

opt.number = true                -- Show absolute line numbers
opt.relativenumber = true        -- Show relative line numbers
opt.tabstop = 2                  -- Number of spaces tabs count for
opt.shiftwidth = 2               -- Number of spaces for autoindent
opt.expandtab = true             -- Use spaces instead of tabs
opt.autoindent = true            -- Auto-indent new lines
opt.scrolloff = 8                -- Keep cursor 8 lines away from screen edge
opt.mouse = 'a'                  -- Enable mouse support
opt.wrap = false                 -- Disable line wrapping
opt.hlsearch = true              -- Highlight search results
opt.incsearch = true             -- Incremental search
opt.smartcase = true             -- Smart case sensitivity for search
opt.termguicolors = true         -- Enable 24-bit color
opt.foldmethod = 'marker'        -- Use markers for folding
opt.foldenable = true            -- Enable folding
opt.foldlevel = 0                -- Start with all folds closed
opt.updatetime = 250             -- Faster update time
opt.splitbelow = true            -- Horizontal splits open below
opt.splitright = true            -- Vertical splits open to the right
opt.termguicolors = true         -- Enable true color support
opt.signcolumn = 'yes'           -- Always show the sign column

-- ------------------------------
-- 3. Bootstrap Lazy.nvim
-- ------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- ------------------------------
-- 4. Plugin Setup with Lazy.nvim
-- ------------------------------
require("lazy").setup({
  -- File explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = 'nvim-tree/nvim-web-devicons' },

  -- Fuzzy finder
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- LSP configurations
  { 'neovim/nvim-lspconfig' },

  -- Autocompletion
  { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' } },

  -- Git signs
  { 'lewis6991/gitsigns.nvim' },

  -- Status line
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Surround text objects
  { 'tpope/vim-surround' },

  -- Colors
  {
    "xiantang/darcula-dark.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    priority = 1000, -- Ensure it loads first
    config = function()
      vim.cmd([[colorscheme darcula-dark]]) -- Apply the theme
    end,
  },

  -- Path utility etc
  { 'nvim-lua/plenary.nvim' },

  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSPconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright"}, -- Add more servers as needed
        automatic_installation = true,
      })
    end,
  },

}, {})

-- ------------------------------
-- 5. Plugin Configurations
-- ------------------------------

-- --- nvim-tree ---
require('nvim-tree').setup {}
vim.keymap.set('n', '<C-f>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- --- Telescope ---
local telescope = require('telescope')
telescope.setup {}
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fl', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })

-- --- Gitsigns ---
require('gitsigns').setup {}

-- --- Lualine ---
require('lualine').setup {}

-- --- Colorscheme ---
-- Already set in Lazy.nvim setup above

-- ------------------------------
-- 6. LSP Configuration
-- ------------------------------
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

-- Common on_attach function for LSP servers
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- LSP Keybindings
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>df', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, opts)
end

-- Setup handlers for LSP servers
mason_lspconfig.setup_handlers({
  -- Default handler for all servers
  function(server_name)
    local opts = {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    }

    -- Specific settings for lua_ls
    if server_name == "lua_ls" then
      opts.settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }, -- Recognize the 'vim' global
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
            checkThirdParty = false, -- Disable annoying third-party notifications
          },
          telemetry = { enable = false }, -- Disable telemetry for performance
        },
      }
    end

    lspconfig[server_name].setup(opts)
  end,
})

-- ------------------------------
-- 7. Autocompletion (nvim-cmp)
-- ------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Using LuaSnip for snippets
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For LuaSnip users
  },
})

-- ------------------------------
-- 8. Additional Keybindings
-- ------------------------------

-- --- Command Mode Shortcut ---
vim.keymap.set('n', ';', ':', { noremap = true, silent = true })

-- --- Quick Saves and Quits ---
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', ':wq<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { noremap = true, silent = true })

-- --- Clipboard Integration ---
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, silent = true })    -- Copy to clipboard
vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, silent = true })    -- Paste from clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, silent = true })

-- --- Search ---
vim.keymap.set('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true }) -- Clear search highlight

-- --- Navigation Between Splits ---
vim.keymap.set('n', '<up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<down>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<left>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<right>', '<C-w>l', { noremap = true, silent = true })

-- --- Moving Lines Up and Down ---
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- --- Center Cursor While Moving ---
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'j', 'gjzz', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gkzz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '}', '}zz', { noremap = true, silent = true })
vim.keymap.set('n', '{', '{zz', { noremap = true, silent = true })

-- --- Folding ---
vim.keymap.set('n', '<leader>o', 'za', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>O', 'zM', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>c', 'zR', { noremap = true, silent = true })

-- --- Quickfix List ---
vim.keymap.set('n', '<leader>co', ':copen<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cc', ':cclose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cn', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cp', ':cprevious<CR>', { noremap = true, silent = true })

-- --- Toggle Relative Line Numbers ---
vim.keymap.set('n', '<leader>n', ':set relativenumber!<CR>', { noremap = true, silent = true })

-- ------------------------------
-- 9. Additional Configurations
-- ------------------------------

-- Enable diagnostics globally
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

