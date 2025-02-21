--: {{{ Basic Settings

-- Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General Settings
local opt = vim.opt
opt.number = true                    -- Show absolute line numbers
opt.relativenumber = true            -- Show relative line numbers
opt.tabstop = 2                      -- Number of spaces tabs count for
opt.shiftwidth = 2                   -- Number of spaces for autoindent
opt.synmaxcol = 200
opt.expandtab = true                 -- Use spaces instead of tabs
opt.autoindent = true                -- Auto-indent new lines
opt.wrap = false                     -- Disable line wrapping
opt.hlsearch = true                  -- Highlight search results
opt.incsearch = true                 -- Incremental search
opt.smartcase = true                 -- Smart case sensitivity for search
opt.ignorecase = true                -- Ignore case
opt.termguicolors = true             -- Enable 24-bit color
opt.foldmethod = 'marker'            -- Use markers for folding
opt.foldenable = true                -- Enable folding
opt.foldlevel = 99                   -- Open all folds by default
opt.updatetime = 50                  -- Reduce update time for responsiveness
opt.splitbelow = true                -- Horizontal splits open below
opt.splitright = true                -- Vertical splits open to the right
opt.signcolumn = 'yes'               -- Always show the sign column
opt.swapfile = false                 -- Disable swap files
opt.backup = false                   -- Disable backup files
opt.writebackup = false              -- Disable backup before overwriting files
opt.background = 'dark'              -- Set background to dark
opt.equalalways = true               -- Always auto-balance splits
vim.g.matchparen_timeout = 20        -- Set timeout for parenthesis matching
vim.g.matchparen_insert_timeout = 20 -- Set timeout for parenthesis insertion

if vim.fn.executable("rg") then
  -- if ripgrep installed, use that as a grepper
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- }}}

--: {{{ Autocommands

-- Cursor moved: center the screen
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    vim.cmd("normal! zz")
  end,
})

-- Window resized: rebalance splits
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- }}}

--: {{{ Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General Keymaps
map('n', ';', ':', { noremap = true, silent = false })
map('n', '<leader>w', ':w<CR>', opts)
map('n', '<leader>q', ':q!<CR>', opts)
map('n', '<leader>h', ':noh<CR>', opts)

-- Window Navigation
map('n', '<up>', '<C-w>k', opts)
map('n', '<down>', '<C-w>j', opts)
map('n', '<left>', '<C-w>h', opts)
map('n', '<right>', '<C-w>l', opts)

-- Moving Lines
map('n', '<C-j>', ':m .+1<CR>==', opts)
map('n', '<C-k>', ':m .-2<CR>==', opts)

-- LSP Keymaps
map('n', 'gd', vim.lsp.buf.definition, opts)            -- Go to definition
map('n', 'gD', vim.lsp.buf.declaration, opts)           -- Go to declaration
map('n', 'gr', vim.lsp.buf.references, opts)            -- List references
map('n', 'gi', vim.lsp.buf.implementation, opts)        -- Go to implementation
map('n', '<leader>rn', vim.lsp.buf.rename, opts)        -- Rename symbol
map('n', '<leader>ca', vim.lsp.buf.code_action, opts)   -- Code actions
map('n', '<leader>bf', vim.lsp.buf.format, opts)        -- Format code
map('n', 'K', vim.lsp.buf.hover, opts)                  -- Hover documentation
map('n', '<leader>cd', vim.diagnostic.open_float, opts) -- Show diagnostics in a float
map('n', '<leader>gf', vim.diagnostic.setqflist, opts)  -- List diagnostics

-- Clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)

-- Removal (delete without yanking)
map({ "n", "v" }, "<leader>d", "\"_d", opts)

-- }}}

--: {{{ Plugin Manager (Lazy)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      require('cmp').setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<Tab>'] = require('cmp').mapping.select_next_item(),
          ['<S-Tab>'] = require('cmp').mapping.select_prev_item(),
          ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })
    end
  },
  {
    'ibhagwan/fzf-lua',
    keys = {
      {
        '<leader>ff',
        function() require('fzf-lua').files() end,
        desc = "Find files"
      },
      {
        '<leader>fg',
        function() require('fzf-lua').live_grep() end,
        desc = "Live grep"
      },
      {
        '<leader>fb',
        function() require('fzf-lua').buffers() end,
        desc = "Buffers"
      },
      {
        '<leader>fl',
        function() require('fzf-lua').blines() end,
        desc = "Current buffer lines"
      },
    },
    config = function()
      require('fzf-lua').setup({
        files = {
          cmd = 'ag --hidden --ignore .git -l -g ""'
        },
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          },
        },
      })
    end
  },
  { 'williamboman/mason.nvim',           event = 'BufReadPre' },
  { 'williamboman/mason-lspconfig.nvim', event = 'BufReadPre' },
  {
    'neovim/nvim-lspconfig',
    ft = { 'lua', 'typescript', 'python', 'cpp' }
  },
  { 'stevearc/oil.nvim', cmd = 'Oil' },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "osc52",
        "spellfile",
      },
    },
  },
}, {
  checker = { enabled = false },
})

require("oil").setup()


-- }}}

--: {{{ LSP Configuration

local lspconfig = require('lspconfig')

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'ts_ls', 'pylsp', 'clangd' },
  automatic_installation = true,
})

-- Lua LSP
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    },
  },
})

-- TypeScript LSP
lspconfig.ts_ls.setup({})

-- Python LSP
lspconfig.pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { "E501" },
          maxLineLength = 120,
        },
      },
    },
  },
})

-- C++ LSP
lspconfig.clangd.setup({})

-- Disable inline diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})

-- }}}

--: {{{ Colorscheme

vim.cmd('colorscheme habamax')

-- }}}
