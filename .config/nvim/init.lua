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
    event = "VimEnter",
    config = function()
      local oil = require('oil')
      oil.setup({
        view_options = { show_hidden = true },
        keymaps = {
          ['<leader>oc'] = oil.discard_all_changes,
        },
      })
    end
  },

  -- Surround editing
  {
    'kylechui/nvim-surround',
    event = "VeryLazy",
    config = function()
      require('nvim-surround').setup()
    end
  },

  -- Autopair
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  -- LSP
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'nvim-lspconfig',
      'williamboman/mason.nvim',
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      vim.lsp.enable({ "pyright", "ruff", "lua_ls" })
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
      })
    end,
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
        ensure_installed = { 'cpp', 'c', 'lua', 'python', 'bash', 'json', 'typescript', 'javascript' },
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

}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
  checker = { enabled = false },
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
local silent_opts = { noremap = true, silent = true }
local opts = { noremap = true, silent = false }
local lsp = vim.lsp.buf
local diag = vim.diagnostic

map('n', 'j', 'gj', silent_opts)
map('n', 'k', 'gk', silent_opts)
map('n', '<leader>rm', ':RmTerms<CR>', silent_opts)
map('n', '<leader>gg', ':!git <Right><Right><Right><Right><Right>', opts)
map('n', '<leader>gd', lsp.definition, silent_opts)
map('n', '<leader>gl', lsp.declaration, silent_opts)
map('n', '<leader>gr', lsp.references, silent_opts)
map('n', '<leader>gi', lsp.implementation, silent_opts)
map('n', '<leader>gh', lsp.hover, silent_opts)
map('n', '<leader>rn', lsp.rename, silent_opts)
map('n', '<leader>ca', lsp.code_action, silent_opts)
map('n', '<leader>fo', lsp.format, silent_opts)
map('n', '<leader>go', lsp.document_symbol, silent_opts)
map('n', '<leader>cd', diag.open_float, silent_opts)
map('n', '<leader>gf', diag.setqflist, silent_opts)
map('n', '<leader>gp', diag.goto_prev, silent_opts)
map('n', '<leader>gn', diag.goto_next, silent_opts)
map('n', '<leader>q', ':q!<CR>', silent_opts)
map('n', '<leader>Q', ':qa!<CR>', silent_opts)
map('n', '<leader>w', ':w<CR>', silent_opts)
map('n', '<leader>l', ':Lazy<CR>', silent_opts)
map('n', '<leader>h', ':noh<CR>', silent_opts)
map('n', '<leader>t', ':term <Right><Right><Right><Right><Right>', opts)
map('n', '<leader>s', ':b#', opts)
map('n', '-', ':Oil<CR>', silent_opts)
map({ 'n', 'v' }, '<leader>y', '"+y', silent_opts)
map({ 'n', 'v' }, '<leader>p', '"+p', silent_opts)
map({ 'i', 'c' }, '<C-h>', '<Left>', opts)
map({ 'i', 'c' }, '<C-j>', '<Down>', opts)
map({ 'i', 'c' }, '<C-k>', '<Up>', opts)
map({ 'i', 'c' }, '<C-l>', '<Right>', opts)
map('c', '<M-b>', '<C-Left>', opts)
map('c', '<M-f>', '<C-Right>', opts)
map('t', '<Esc>', '<C-\\><C-n>', opts)
--: }}}
