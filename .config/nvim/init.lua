--: {{{ Basic Settings

-- Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General Settings
local opt = vim.opt
opt.number = true         -- Show absolute line numbers
opt.relativenumber = true -- Show relative line numbers
opt.tabstop = 2           -- Number of spaces tabs count for
opt.shiftwidth = 2        -- Number of spaces for autoindent
opt.expandtab = true      -- Use spaces instead of tabs
opt.autoindent = true     -- Auto-indent new lines
opt.scrolloff = 8         -- Keep cursor 8 lines away from screen edge
opt.mouse = 'a'           -- Enable mouse support
opt.wrap = false          -- Disable line wrapping
opt.hlsearch = true       -- Highlight search results
opt.incsearch = true      -- Incremental search
opt.smartcase = true      -- Smart case sensitivity for search
opt.termguicolors = true  -- Enable 24-bit color
opt.foldmethod = 'marker' -- Use markers for folding
opt.foldenable = true     -- Enable folding
opt.foldlevel = 99        -- Open all folds by default
opt.updatetime = 100      -- Reduce update time for responsiveness
opt.splitbelow = true     -- Horizontal splits open below
opt.splitright = true     -- Vertical splits open to the right
opt.signcolumn = 'yes'    -- Always show the sign column
vim.opt.swapfile = false  -- Disable swap files
opt.backup = false        -- Disable backup files
opt.writebackup = false   -- Disable backup before overwriting files
opt.undofile = true       -- Enable persistent undo
opt.background = 'dark'   -- Set background to dark

-- }}}

--: {{{ Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General Keymaps
map('n', ';', ':', { noremap = true, silent = false })
map('n', '<leader>w', ':w<CR>', opts)
map('n', '<leader>W', ':wq<CR>', opts)
map('n', '<leader>q', ':q<CR>', opts)
map('n', '<leader>Q', ':q!<CR>', opts)
map('n', '<leader>y', '"+y', opts)
map('n', '<leader>p', '"+p', opts)
map('v', '<leader>y', '"+y', opts)
map('v', '<leader>p', '"+p', opts)
map('n', '<leader>h', ':noh<CR>', opts)

-- Window Navigation
map('n', '<up>', '<C-w>k', opts)
map('n', '<down>', '<C-w>j', opts)
map('n', '<left>', '<C-w>h', opts)
map('n', '<right>', '<C-w>l', opts)

-- Moving Lines
map('n', '<C-j>', ':m .+1<CR>==', opts)
map('n', '<C-k>', ':m .-2<CR>==', opts)
map('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
map('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)

-- Search
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Scrolling and Folding
map('n', 'j', 'gjzz', opts)
map('n', 'k', 'gkzz', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '}', '}zz', opts)
map('n', '{', '{zz', opts)

-- Quickfix
map('n', '<leader>co', ':copen<CR>', opts)
map('n', '<leader>cc', ':cclose<CR>', opts)
map('n', '<leader>cn', ':cnext<CR>zz', opts)
map('n', '<leader>cp', ':cprevious<CR>zz', opts)

-- Indentation
map('n', '<', '<<', opts)
map('n', '>', '>>', opts)
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- LSP Keymaps
map('n', 'gd', vim.lsp.buf.definition, opts)            -- Go to definition
map('n', 'gD', vim.lsp.buf.declaration, opts)           -- Go to declaration
map('n', 'gr', vim.lsp.buf.references, opts)            -- List references
map('n', 'gi', vim.lsp.buf.implementation, opts)        -- Go to implementation
map('n', '<leader>rn', vim.lsp.buf.rename, opts)        -- Rename symbol
map('n', '<leader>ca', vim.lsp.buf.code_action, opts)   -- Code actions
map('n', '<leader>bf', vim.lsp.buf.format, opts)        -- Format code
map('n', 'K', vim.lsp.buf.hover, opts)                  -- Hover documentation
map('n', '<leader>sh', vim.lsp.buf.signature_help, opts)     -- Signature help
map('n', '<leader>cd', vim.diagnostic.open_float, opts) -- Show detailed diagnostics in a floating window
map('n', '<leader>gf', vim.diagnostic.setqflist, opts)  -- Send all diagnostics to the quickfix list

-- Telescope Keymaps
map('n', '<leader>ff', '<cmd>Telescope find_files hidden=true no_ignore=true<CR>', opts) -- Find files
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)  -- Live grep
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)    -- List open buffers
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)  -- Help tags
map('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>', opts)   -- Recently opened files

-- Clipboard
map({'n', 'v'}, '<leader>y', '"+y', opts)
map({'n', 'v'}, '<leader>p', '"+p', opts)

-- Removal
map({"n", "v"}, "<leader>d", "\"_d") -- Remove without overwriting register content

--- Search and replace
map('n', ';;', ':%s:::g<Left><Left><Left>', {noremap = true, silent = false})
map('n', ";'", ':%s:::cg<Left><Left><Left><Left>', {noremap = true,
silent = false})
map('c', ";\\", '\\(\\)<Left><Left>', {noremap = true, silent = false})

-- Command mode navigation
map('c', '<C-a>', '<Home>', {noremap = true, silent = false})
map('c', '<C-e>', '<End>', {noremap = true, silent = false})
map('c', '<C-p>', '<Up>', {noremap = true, silent = false})
map('c', '<C-n>', '<Down>', {noremap = true, silent = false})
map('c', '<C-b>', '<Left>', {noremap = true, silent = false})
map('c', '<C-f>', '<Right>', {noremap = true, silent = false})
map('c', '<M-b>', '<S-Left>', {noremap = true, silent = false})
map('c', '<M-f>', '<S-Right>', {noremap = true, silent = false})

-- }}}

--: {{{ Plugin Manager (Lazy)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- LSP Plugins
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim',           config = true },
  { 'williamboman/mason-lspconfig.nvim', config = true },

  -- Telescope
  { 'nvim-telescope/telescope.nvim',     tag = '0.1.1', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- File manager
  {
    "https://github.com/stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Browse files from here" },
    },
  },

  -- Git integration
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
  }


})

-- }}}

--: {{{ LSP Configuration

local lspconfig = require('lspconfig')
require('mason').setup()
require('mason-lspconfig').setup({
 ensure_installed = { 'lua_ls', 'ts_ls', 'pylsp', 'clangd' },
})

-- Lua
lspconfig.lua_ls.setup({
 settings = {
   Lua = {
     diagnostics = { globals = { 'vim' } },
   },
 },
})

-- TypeScript
lspconfig.ts_ls.setup({
 root_dir = lspconfig.util.root_pattern('.git'),
})

-- Python
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
 root_dir = lspconfig.util.root_pattern('.git'),
})

-- C++
lspconfig.clangd.setup({
 root_dir = lspconfig.util.root_pattern('.git'),
})

-- Disable inline diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- }}}

--: {{{ Colorscheme

vim.cmd('colorscheme habamax')

-- }}}
