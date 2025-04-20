--: {{{ Basic Settings

local g                     = vim.g
local opt                   = vim.opt
local cmd                   = vim.cmd
local fn                    = vim.fn
local api                   = vim.api
local lsp_buf               = vim.lsp.buf
local lsp_diag              = vim.diagnostic
local map                   = vim.keymap.set
local opts                  = { noremap = true, silent = true }
local lazypath              = fn.stdpath('data') .. '/lazy/lazy.nvim'

g.mapleader                 = ' '
g.maplocalleader            = ' '
g.matchparen_timeout        = 20
g.matchparen_insert_timeout = 20

opt.number                  = true
opt.relativenumber          = true
opt.tabstop                 = 2
opt.shiftwidth              = 2
opt.expandtab               = true
opt.autoindent              = true
opt.wrap                    = false
opt.hlsearch                = true
opt.incsearch               = true
opt.smartcase               = true
opt.ignorecase              = true
opt.termguicolors           = true
opt.foldmethod              = 'marker'
opt.foldenable              = true
opt.foldlevel               = 0
opt.updatetime              = 50
opt.splitbelow              = true
opt.splitright              = true
opt.signcolumn              = 'yes'
opt.swapfile                = false
opt.backup                  = false
opt.writebackup             = false
opt.background              = 'dark'
opt.equalalways             = true
opt.lazyredraw              = true
opt.grepprg                 = 'rg --vimgrep --no-heading --smart-case'
opt.grepformat              = '%f:%l:%c:%m,%f:%l:%m'

cmd('colorscheme habamax')

--: }}}

--: {{{ Plugins

if not vim.loop.fs_stat(lazypath) then
  fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.ngit',
    '--branch=stable',
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

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
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp'
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
        desc = 'Current buffer lines'
      },
    },
    config = function()
      require('fzf-lua').setup({
        'border-fused',
        files = {
          cmd = 'fd --type f --hidden --follow --exclude .git',
        },
        grep = {
          cmd = 'rg --column --color=never --no-heading --line-number --hidden --smart-case'
        },
        keymap = {
          fzf = {
            ['ctrl-q'] = 'select-all+accept',
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
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end
  }

}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'osc52',
        'spellfile',
      },
    },
  },
  checker = { enabled = false },

})

local oil = require('oil')
oil.setup({
  watch_for_changes = true,
  keymaps = {
    ['<leader>oc'] = oil.discard_all_changes,
  },
  view_options = {
    show_hidden = true,
  },
})

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
          ignore = { 'E501' },
          maxLineLength = 120,
        },
      },
    },
  },
})
lspconfig.clangd.setup({})
lsp_diag.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})

--: }}}

--: {{{ Custom functions

api.nvim_create_autocmd({ 'CursorMoved', 'VimResized' }, {
  callback = function(event)
    if event.event == 'CursorMoved' then
      cmd('normal! zz')
    else
      cmd('wincmd =')
    end
  end,
})

local function RemoveTerminalBuffers()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      api.nvim_buf_delete(buf, { force = true })
    end
  end
end
api.nvim_create_user_command('RmTerms', RemoveTerminalBuffers, {})

local function Quit()
  oil.discard_all_changes()
  cmd('q!')
end
api.nvim_create_user_command('Quit', Quit, {})

--: }}}

--: {{{ Keymaps

map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)
map('n', '<leader>cn', ':copen<CR>', opts)
map('n', '<leader>cc', ':cclose<CR>', opts)
map('n', '<leader>cn', ':cnext<CR>', opts)
map('n', '<leader>ce', ':cend<CR>', opts)
map('n', '<leader>cp', ':cprev<CR>', opts)
map('n', '<leader>cb', ':cbegin<CR>', opts)
map('n', '<leader>rm', ':RmTerms<CR>', opts)
map('n', '<leader>gg', ':!git <Right><Right><Right><Right><Right>')
map('n', '<leader>gd', lsp_buf.definition, opts)
map('n', '<leader>gl', lsp_buf.declaration, opts)
map('n', '<leader>gr', lsp_buf.references, opts)
map('n', '<leader>gi', lsp_buf.implementation, opts)
map('n', '<leader>gh', lsp_buf.hover, opts)
map('n', '<leader>rn', lsp_buf.rename, opts)
map('n', '<leader>ca', lsp_buf.code_action, opts)
map('n', '<leader>fo', lsp_buf.format, opts)
map('n', '<leader>go', lsp_buf.document_symbol, opts)
map('n', '<leader>cd', lsp_diag.open_float, opts)
map('n', '<leader>gf', lsp_diag.setqflist, opts)
map('n', '<leader>q', ':Quit<CR>', opts)
map('n', '<leader>w', ':w<CR>', opts)
map('n', '<leader>l', ':Lazy<CR>', opts)
map('n', '<leader>h', ':noh<CR>', opts)
map('n', '<leader>t', ':term <Right><Right><Right><Right><Right>', { noremap = true, silent = false })
map('n', '<leader>rr', ':@:<CR>', { noremap = true, silent = false })
map('n', '-', ':Oil<CR>', opts)
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)
map({ 'n', 'v' }, '<leader>m', ':let @*=trim(execute(\"1messages\"))<cr>', opts)
map({ 'n', 'v' }, '<leader>d', "\'_d", opts)

--: }}}
