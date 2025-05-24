--: {{{ Basic Settings

local g, opt, cmd, fn, api = vim.g, vim.opt, vim.cmd, vim.fn, vim.api
g.mapleader = ' '
g.maplocalleader = ' '
g.matchparen_timeout = 20
g.matchparen_insert_timeout = 20

opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.termguicolors = true
opt.foldmethod = 'marker'
opt.foldenable = true
opt.foldlevel = 20
opt.updatetime = 100
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = 'yes'
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.background = 'dark'
opt.equalalways = true
opt.lazyredraw = true
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'

cmd('colorscheme habamax')

--: }}}

--: {{{ Lazy Plugin Setup

local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim', '--branch=stable', lazypath })
end
opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
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

  -- Fuzzy finder
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<leader>ff', function() require('fzf-lua').files() end,     desc = "Find files" },
      { '<leader>fg', function() require('fzf-lua').live_grep() end, desc = "Live grep" },
      { '<leader>fb', function() require('fzf-lua').buffers() end,   desc = "Buffers" },
      { '<leader>fl', function() require('fzf-lua').blines() end,    desc = 'Current buffer lines' },
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

  -- File explorer
  {
    'stevearc/oil.nvim',
    lazy = false,
    config = function()
      local oil = require('oil')
      oil.setup({
        view_options = { show_hidden = true },
        keymaps = {
          ['<leader>oc'] = oil.discard_all_changes,
        },
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local arg = vim.fn.argv()[1]
          if arg and vim.fn.isdirectory(arg) == 1 then
            vim.cmd("Oil")
          end
        end,
      })
    end
  },

  -- Surround editing
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end
  },


  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    ft = { 'lua', 'typescript', 'python', 'cpp' },
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'williamboman/mason.nvim' },
    },
  },
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'williamboman/mason.nvim'
    },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {},
      })
    end
  },

  -- Autopair
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'cpp', 'c', 'lua', 'python', 'bash', 'json' },
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- Functions
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",

              -- Classes
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",

              -- Parameters
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",

              -- Loops
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",

              -- Conditionals
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",

              -- Comments
              ["a/"] = "@comment.outer",

              -- Variables
              ["av"] = "@assignment.outer",
              ["iv"] = "@assignment.inner",
            },
          },

          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
              ["]l"] = "@loop.outer",
              ["]i"] = "@conditional.outer",
              ["]/"] = "@comment.outer",
              ["]v"] = "@assignment.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
              ["[l"] = "@loop.outer",
              ["[i"] = "@conditional.outer",
              ["[/"] = "@comment.outer",
              ["[v"] = "@assignment.outer",
            },
          },
        },
      }
    end,
  }
  ,

}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip', 'netrwPlugin', 'tarPlugin', 'tohtml',
        'tutor', 'zipPlugin', 'osc52', 'spellfile', 'matchit',
      },
    },
  },
  checker = { enabled = false },
})

local lspconfig = require('lspconfig')
local lsp_diag = vim.diagnostic

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
})
lspconfig.ts_ls.setup({})
lspconfig.pylsp.setup({})
lspconfig.clangd.setup({})

lsp_diag.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
})

--: }}}

--: {{{ Custom Functions

api.nvim_create_user_command('RmTerms', function()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      api.nvim_buf_delete(buf, { force = true })
    end
  end
end, {})

api.nvim_create_autocmd({ 'CursorMoved', 'VimResized' }, {
  callback = function(event)
    if event.event == 'CursorMoved' then
      if not vim.bo.buftype:match("terminal") then
        cmd('normal! zz')
      end
    else
      cmd('wincmd =')
    end
  end,
})

--: }}}

--: {{{ Keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local lsp = vim.lsp.buf
local diag = vim.diagnostic

map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)
map('n', '<leader>cn', ':copen<CR>', opts)
map('n', '<leader>cc', ':cclose<CR>', opts)
map('n', '<leader>ce', ':cend<CR>', opts)
map('n', '<leader>cp', ':cprev<CR>', opts)
map('n', '<leader>cb', ':cbegin<CR>', opts)
map('n', '<leader>rm', ':RmTerms<CR>', opts)
map('n', '<leader>gg', ':!git <Right><Right><Right><Right><Right>')
map('n', '<leader>gd', lsp.definition, opts)
map('n', '<leader>gl', lsp.declaration, opts)
map('n', '<leader>gr', lsp.references, opts)
map('n', '<leader>gi', lsp.implementation, opts)
map('n', '<leader>gh', lsp.hover, opts)
map('n', '<leader>rn', lsp.rename, opts)
map('n', '<leader>ca', lsp.code_action, opts)
map('n', '<leader>fo', lsp.format, opts)
map('n', '<leader>go', lsp.document_symbol, opts)
map('n', '<leader>cd', diag.open_float, opts)
map('n', '<leader>gf', diag.setqflist, opts)
map('n', '<leader>gp', diag.goto_prev, opts)
map('n', '<leader>gn', diag.goto_next, opts)
map('n', '<leader>q', ':q!<CR>', opts)
map('n', '<leader>Q', ':qa!<CR>', opts)
map('n', '<leader>w', ':w<CR>', opts)
map('n', '<leader>l', ':Lazy<CR>', opts)
map('n', '<leader>h', ':noh<CR>', opts)
map('n', '<leader>t', ':term <Right><Right><Right><Right><Right>', { noremap = true, silent = false })
map('n', '-', ':Oil<CR>', opts)
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)
map({ 'n', 'v' }, '<leader>m', ':let @*=trim(execute("1messages"))<cr>', opts)
map({ 'n', 'v' }, '<leader>d', "'_d", { silent = false })
map({ 'i', 'c' }, '<C-h>', '<Left>', { silent = false })
map({ 'i', 'c' }, '<C-j>', '<Down>', { silent = false })
map({ 'i', 'c' }, '<C-k>', '<Up>', { silent = false })
map({ 'i', 'c' }, '<C-l>', '<Right>', { silent = false })
map('c', '<M-b>', '<C-Left>', { silent = false })
map('c', '<M-f>', '<C-Right>', { silent = false })
map('t', '<Esc>', '<C-\\><C-n>', { silent = false })
map('t', '<A-h>', '<C-\\><C-N><C-w>h', { silent = false })
map('t', '<A-j>', '<C-\\><C-N><C-w>j', { silent = false })
map('t', '<A-k>', '<C-\\><C-N><C-w>k', { silent = false })
map('t', '<A-l>', '<C-\\><C-N><C-w>l', { silent = false })
map('t', '<A-h>', '<C-\\><C-N><C-w>h', { silent = false })
map('t', '<A-j>', '<C-\\><C-N><C-w>j', { silent = false })
map('t', '<A-k>', '<C-\\><C-N><C-w>k', { silent = false })
map('t', '<A-l>', '<C-\\><C-N><C-w>l', { silent = false })
map('t', '<A-h>', '<C-w>h', { silent = false })
map('t', '<A-j>', '<C-w>j', { silent = false })
map('t', '<A-k>', '<C-w>k', { silent = false })
map('t', '<A-l>', '<C-w>l', { silent = false })
--: }}}
