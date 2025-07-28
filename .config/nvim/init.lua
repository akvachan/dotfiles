--: {{{ Basic Settings

local g, opt, cmd, fn, api = vim.g, vim.opt, vim.cmd, vim.fn, vim.api
g.copilot_enabled = false
g.copilot_no_tab_map = true
g.mapleader = ' '
g.maplocalleader = ' '
g.matchparen_insert_timeout = 20
g.matchparen_timeout = 20
opt.autoindent = true
opt.background = 'dark'
opt.backup = false
opt.equalalways = true
opt.expandtab = true
opt.foldenable = true
opt.foldlevel = 20
opt.foldmethod = 'marker'
opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.lazyredraw = true
opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.scrolloff = 1000
opt.shiftwidth = 2
opt.signcolumn = 'yes'
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.updatetime = 100
opt.wrap = false
opt.writebackup = false

--: }}}

--: {{{ Lazy Plugin Setup

local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim', '--branch=stable', lazypath })
end
opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Leetcode stuff
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "cpp",
      keys = {
        toggle = { "q" },
        confirm = { "<CR>" },
        reset_testcases = "r",
        use_testcase = "U",
        focus_testcases = "H",
        focus_result = "L",
      },
    },
  },

  -- Colorscheme
  {
    'projekt0n/github-nvim-theme',
    config = function()
      vim.cmd.colorscheme('github_dark_dimmed')
    end
  },

  -- Copilot
  {
    'github/copilot.vim',
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
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
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
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
      { '<leader>ff', function() require('fzf-lua').files() end,     desc = 'Find files' },
      { '<leader>fg', function() require('fzf-lua').live_grep() end, desc = 'Live grep' },
      { '<leader>fb', function() require('fzf-lua').buffers() end,   desc = 'Buffers' },
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
    event = 'VimEnter',
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
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end
  },

  -- Autopair
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },

  -- LSP
  {
    'nvim-lspconfig',
    event = 'VeryLazy',
    config = function()
      vim.lsp.enable({ 'clangd', 'bashls', 'pyright', 'ruff', 'lua_ls' })
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
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
      }
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
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              -- Classes
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              -- Parameters
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              -- Loops
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              -- Conditionals
              ['ai'] = '@conditional.outer',
              ['ii'] = '@conditional.inner',
              -- Comments
              ['a/'] = '@comment.outer',
              -- Variables
              ['av'] = '@assignment.outer',
              ['iv'] = '@assignment.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']c'] = '@class.outer',
              [']a'] = '@parameter.inner',
              [']l'] = '@loop.outer',
              [']i'] = '@conditional.outer',
              [']/'] = '@comment.outer',
              [']v'] = '@assignment.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[c'] = '@class.outer',
              ['[a'] = '@parameter.inner',
              ['[l'] = '@loop.outer',
              ['[i'] = '@conditional.outer',
              ['[/'] = '@comment.outer',
              ['[v'] = '@assignment.outer',
            },
          },
        },
      }
    end,
  },

}, {
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'matchit',
        'tar',
        'tarPlugin',
        'rrhelper',
        'spellfile_plugin',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
        'tutor',
        'rplugin',
        'syntax',
        'synmenu',
        'optwin',
        'compiler',
        'bugreport',
        'ftplugin',
      },
    },
  },
  checker = { enabled = false },
})

--: }}}

--: {{{ Custom Functions

-- Delete terminal buffers
api.nvim_create_user_command('RmTerms', function()
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      api.nvim_buf_delete(buf, { force = true })
    end
  end
end, {})

-- Automatically source virtual environment
api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local cwd = vim.fn.getcwd()
    local venv_path = cwd .. '/.venv/bin/activate'
    if vim.fn.filereadable(venv_path) == 1 then
      vim.env.VIRTUAL_ENV = cwd .. '/.venv'
      vim.env.PATH = cwd .. '/.venv/bin:' .. vim.env.PATH
    end
  end,
  pattern = '*',
  group = vim.api.nvim_create_augroup('AutoActivateVenv', { clear = true }),
})

-- Resize vim automatically
api.nvim_create_autocmd('VimResized', {
  callback = function()
    cmd('wincmd =')
  end,
})

-- Toggle copilot
local function toggle_copilot()
  if g.copilot_enabled then
    cmd('Copilot disable')
    print('Copilot disabled')
    g.copilot_enabled = false
  else
    cmd('Copilot enable')
    print('Copilot enabled')
    g.copilot_enabled = true
  end
end

--: }}}

--: {{{ Keymaps

local copilot_opts = { expr = true, replace_keycodes = false }
local diag = vim.diagnostic
local lsp = vim.lsp.buf
local map = vim.keymap.set
local opts = { noremap = true, silent = false }
local silent_opts = { noremap = true, silent = true }

map('c', '<C-h>', '<C-Left>', opts)
map('c', '<C-l>', '<C-Right>', opts)
map('i', '<C-c>', '<Plug>(copilot-dismiss)', silent_opts)
map('i', '<C-f>', 'copilot#Accept("\\<CR>")', copilot_opts)
map('i', '<C-j>', '<Plug>(copilot-next)', silent_opts)
map('i', '<C-k>', '<Plug>(copilot-previous)', silent_opts)
map('i', '<C-l>', '<Plug>(copilot-accept-word)', silent_opts)
map('n', '-', ':Oil<CR>', silent_opts)
map('n', '<C-g>', toggle_copilot, silent_opts)
map('n', '<leader>Q', ':qa!<CR>', silent_opts)
map('n', '<leader>bd', ':bp|bd #<CR>', silent_opts)
map('n', '<leader>ca', lsp.code_action, silent_opts)
map('n', '<leader>cc', ':ccl<CR>', silent_opts)
map('n', '<leader>cd', diag.open_float, silent_opts)
map('n', '<leader>cf', ':cnf<CR>', silent_opts)
map('n', '<leader>cn', ':cn<CR>', silent_opts)
map('n', '<leader>co', ':copen<CR>', silent_opts)
map('n', '<leader>cp', ':cp<CR>', silent_opts)
map('n', '<leader>cu', ':.cc<CR>', silent_opts)
map('n', '<leader>fo', lsp.format, silent_opts)
map('n', '<leader>gd', lsp.definition, silent_opts)
map('n', '<leader>gf', diag.setqflist, silent_opts)
map('n', '<leader>gg', ':<C-u>!git ', opts)
map('n', '<leader>gh', lsp.hover, silent_opts)
map('n', '<leader>gi', lsp.implementation, silent_opts)
map('n', '<leader>gl', lsp.declaration, silent_opts)
map('n', '<leader>gn', diag.goto_next, silent_opts)
map('n', '<leader>go', lsp.document_symbol, silent_opts)
map('n', '<leader>gp', diag.goto_prev, silent_opts)
map('n', '<leader>gr', lsp.references, silent_opts)
map('n', '<leader>h', ':noh<CR>', silent_opts)
map('n', '<leader>l', ':Lazy<CR>', silent_opts)
map('n', '<leader>q', ':q!<CR>', silent_opts)
map('n', '<leader>rm', ':RmTerms<CR>', silent_opts)
map('n', '<leader>rn', lsp.rename, silent_opts)
map('n', '<leader>s', ':b#<CR>', silent_opts)
map('n', '<leader>t', ':<C-u>term ', opts)
map('n', '<leader>w', ':w<CR>', silent_opts)
map('n', '<leader>z', ':u0<CR>', silent_opts)
map('n', 'B', '^', silent_opts)
map('n', 'E', '$', silent_opts)
map('n', 'j', 'gj', silent_opts)
map('n', 'k', 'gk', silent_opts)
map('t', '<Esc>', '<C-\\><C-n>', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', silent_opts)
map({ 'n', 'v' }, '<leader>y', '"+y', silent_opts)

--: }}}
