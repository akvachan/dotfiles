--: {{{ Basic Settings

-- Leader Key
vim.g.mapleader                 = ' '
vim.g.maplocalleader            = ' '

-- Disable unused built-in plugins for performance
vim.g.loaded_netrw              = 1
vim.g.loaded_netrwPlugin        = 1
vim.g.loaded_tar                = 1
vim.g.loaded_tarPlugin          = 1
vim.g.loaded_zip                = 1
vim.g.loaded_zipPlugin          = 1
vim.g.loaded_gzip               = 1
vim.g.loaded_matchparen         = 1

-- General Editor Options
local opt                       = vim.opt
opt.number                      = true     -- Show absolute line numbers
opt.relativenumber              = true     -- Show relative line numbers
opt.tabstop                     = 2        -- Number of spaces tabs count for
opt.shiftwidth                  = 2        -- Spaces for auto-indent
opt.expandtab                   = true     -- Use spaces instead of tabs
opt.autoindent                  = true     -- Auto-indent new lines
opt.wrap                        = false    -- Disable line wrapping
opt.hlsearch                    = true     -- Highlight search results
opt.incsearch                   = true     -- Incremental search
opt.smartcase                   = true     -- Smart case sensitivity for search
opt.ignorecase                  = true     -- Ignore case
opt.termguicolors               = true     -- Enable 24-bit color
opt.foldmethod                  = 'marker' -- Use markers for folding
opt.foldenable                  = true     -- Enable folding
opt.foldlevel                   = 0        -- Always fold
opt.updatetime                  = 50       -- Faster responsiveness
opt.splitbelow                  = true     -- Horizontal splits open below
opt.splitright                  = true     -- Vertical splits open to the right
opt.signcolumn                  = 'yes'    -- Always show the sign column
opt.swapfile                    = false    -- Disable swap files
opt.backup                      = false    -- Disable backup files
opt.writebackup                 = false    -- Disable backup before overwriting files
opt.background                  = 'dark'   -- Set background to dark
opt.equalalways                 = true     -- Always auto-balance splits
opt.lazyredraw                  = true     -- Optimize screen redraw during macros

-- Parenthesis matching timeouts
vim.g.matchparen_timeout        = 20
vim.g.matchparen_insert_timeout = 20

-- Use ripgrep if installed
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

--: }}}

--: {{{ Plugins

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
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp"
      }
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-c>'] = cmp.mapping.close(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
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
  { 'neovim/nvim-lspconfig',             ft = { 'lua', 'typescript', 'python', 'cpp' } },
  { 'stevearc/oil.nvim',                 cmd = 'Oil' },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    version = '^6.0.0',
    config = function()
      require('kitty-scrollback').setup()
    end,
  }
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
  checker = { enabled = false },
})

require('oil').setup()

--: }}}

--: {{{ Autocommands

-- Combined autocmd for performance: minimize callbacks during cursor and window events.
vim.api.nvim_create_autocmd({ "CursorMoved", "VimResized" }, {
  callback = function(event)
    if event.event == "CursorMoved" then
      vim.cmd("normal! zz")
    else
      vim.cmd("wincmd =")
    end
  end,
})

--: }}}

--: {{{ Custom Functions

local function RemoveTerminalBuffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end
vim.api.nvim_create_user_command('RmTerms', RemoveTerminalBuffers, {})

--: }}}

--: {{{ Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General Keymaps
map('n', '<leader>w', ':w<CR>', opts)
map('n', '<leader>l', ':Lazy<CR>', opts)
map('n', '<leader>q', ':q!<CR>', opts)
map('n', '<leader>h', ':noh<CR>', opts)
map('n', '\\', ':term <Right><Right><Right><Right><Right>', { noremap = true, silent = false })

-- Window Navigation
map('n', '<up>', '<C-w>k', opts)
map('n', '<down>', '<C-w>j', opts)
map('n', '<left>', '<C-w>h', opts)
map('n', '<right>', '<C-w>l', opts)

-- LSP Keymaps
map('n', 'gd', vim.lsp.buf.definition, opts)
map('n', 'gD', vim.lsp.buf.declaration, opts)
map('n', 'gr', vim.lsp.buf.references, opts)
map('n', 'gi', vim.lsp.buf.implementation, opts)
map('n', 'K', vim.lsp.buf.hover, opts)
map('n', '<leader>rn', vim.lsp.buf.rename, opts)
map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
map('n', '<leader>fo', vim.lsp.buf.format, opts)
map('n', '<leader>cd', vim.diagnostic.open_float, opts)
map('n', '<leader>gf', vim.diagnostic.setqflist, opts)

-- Clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)

-- Removal (delete without yanking)
map({ "n", "v" }, "<leader>d", "\"_d", opts)

-- Oil Explorer
map({ "n", "v" }, "-", ":Oil<CR>", opts)

-- Quickfix Navigation
map('n', '<leader>co', ':copen<CR>', opts)
map('n', '<leader>cc', ':cclose<CR>', opts)
map('n', '<leader>cn', ':cnext<CR>', opts)
map('n', '<leader>ce', ':cend<CR>', opts)
map('n', '<leader>cp', ':cprev<CR>', opts)
map('n', '<leader>cb', ':cbegin<CR>', opts)

-- Custom functions, methods and tools
map('n', '<leader>rm', ':RmTerms<CR>', opts)

--: }}}

--: {{{ LSP

local lspconfig = require('lspconfig')

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'ts_ls', 'pylsp', 'clangd' },
  automatic_installation = true,
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    },
  },
})

lspconfig.ts_ls.setup({})

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

lspconfig.clangd.setup({})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})

--: }}}

--: {{{ Colorscheme

vim.cmd('colorscheme habamax')

--: }}}
