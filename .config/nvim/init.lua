# vim:fileencoding=utf-8:foldmethod=marker

-- {{{ Basic Settings

local g, opt, cmd, fn, api = vim.g, vim.opt, vim.cmd, vim.fn, vim.api
opt.autoindent = true
opt.background = 'dark'
opt.backup = false
opt.equalalways = true
opt.expandtab = true
opt.foldenable = true
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
g.copilot_enabled = false
g.copilot_no_tab_map = true
g.mapleader = ' '
g.maplocalleader = ' '
g.matchparen_insert_timeout = 20
g.matchparen_timeout = 20

-- }}}

-- {{{ Plugins

-- {{{ Lazy Setup
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim', '--branch=stable',
    lazypath })
end
opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- }}}

  -- {{{ XCode DevOps
  {
    "wojciech-kulik/xcodebuild.nvim",
    ft = "swift",
    dependencies = {
      "ibhagwan/fzf-lua",
      "MunifTanjim/nui.nvim",
      "stevearc/oil.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("xcodebuild").setup({})
    end,
  },
  -- }}}

  -- {{{ Completion
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = "InsertEnter",
    version = '1.*',
    opts = {
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      keymap = { preset = 'super-tab' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = true } },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' }, },
      fuzzy = { implementation = "prefer_rust" },
    },
    opts_extend = { "sources.default" }
  },
  -- }}}

  -- {{{ Autopair
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },
  -- }}}

  -- {{{ Colorscheme
  {
    'projekt0n/github-nvim-theme',
    config = function()
      vim.cmd.colorscheme('github_dark_dimmed')
    end
  },
  -- }}}

  -- {{{ File explorer
  {
    'stevearc/oil.nvim',
    event = 'VimEnter',
    config = function()
      local oil = require('oil')
      oil.setup({
        columns = {
          'permissions',
          'size',
          { 'mtime', highlight = 'Comment', format = '%Y-%m-%d %H:%M' },
        },
        view_options = { show_hidden = true },
        keymaps = {
          -- Copy absolute path
          ['<leader>oy'] = {
            desc = 'Copy filepath to system clipboard',
            callback = function()
              require('oil.actions').copy_entry_path.callback()
              vim.fn.setreg('+', vim.fn.getreg(vim.v.register))
            end,
          },
          -- Copy relative path
          ['<leader>or'] = {
            callback = function()
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if not entry or not dir then
                return
              end
              local relpath = vim.fn.fnamemodify(dir, ':.')
              vim.fn.setreg('+', relpath .. entry.name)
            end,
          },
          -- Discard all filesystem changes
          ['<leader>oc'] = oil.discard_all_changes,
        },
      })
    end
  },
  -- }}}

  -- {{{ Fuzzy finder
  {
    'ibhagwan/fzf-lua',
    keys = {
      { '<leader>ff', function() require('fzf-lua').files() end,                 desc = 'Find files' },
      { '<leader>fg', function() require('fzf-lua').live_grep() end,             desc = 'Live grep' },
      { '<leader>fb', function() require('fzf-lua').buffers() end,               desc = 'Buffers' },
      { '<leader>fl', function() require('fzf-lua').blines() end,                desc = 'Current buffer lines' },
      { '<leader>fr', function() require('fzf-lua').resume() end,                desc = 'Resume work' },
      { '<leader>sd', function() require('fzf-lua').lsp_document_symbols() end,  desc = 'Symbols (document)' },
      { '<leader>sw', function() require('fzf-lua').lsp_workspace_symbols() end, desc = 'Symbols (workspace)' },
    },
    config = function()
      require('fzf-lua').setup({
        'border-fused',
        files = {
          cmd = 'fd --type f --hidden --follow --exclude .git',
          actions = {
            -- Copy file path
            ["ctrl-y"] = function(selected)
              local path = selected[1]
              vim.fn.setreg("+", path)
              print("Copied: " .. path)
            end,
          },
        },
        grep = {
          cmd = 'rg --column --color=never --no-heading --line-number --hidden --smart-case',
        },
        keymap = {
          fzf = {
            -- Send selection to quickfix list
            ['ctrl-q'] = 'select-all+accept',
          },
        },
      })
    end,
  },
  -- }}}

  -- {{{ LSP
  {
    'nvim-lspconfig',
    event = 'VeryLazy',
    init = function()
      local make_client_capabilities = vim.lsp.protocol.make_client_capabilities
      function vim.lsp.protocol.make_client_capabilities()
        local caps = make_client_capabilities()
        if caps.workspace then
          caps.workspace.didChangeWatchedFiles = nil
        end
        return caps
      end
    end,
    config = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = false,
        update_in_insert = false,
        severity_sort = true,
      })

      -- {{{ Go LSP config
      vim.lsp.config('gopls', {
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              unusedwrite = true,
              unusedvariable = true,
              useany = true,
              shadow = true,
              nilness = true,
              printf = true,
              composites = true,
              httpresponse = true,
              infertypeargs = true,
              loopclosure = true,
              lostcancel = true,
              nonewvars = true,
              shift = true,
              simplifycompositelit = true,
              simplifyrange = true,
              simplifyslice = true,
              slog = true,
              sortslice = true,
              stdmethods = true,
              stringintconv = true,
              testinggoroutine = true,
              timeformat = true,
              undeclaredname = true,
              unmarshal = true,
              unreachable = true,
              unsafeptr = true,
              fillstruct = true,
              fillreturns = true,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      -- }}}

      vim.lsp.enable({
        -- C (type checker)
        'clangd',
        -- Rust (type checker)
        'rust_analyzer',
        -- Lua (type checker)
        'lua_ls',
        -- Python (type checker)
        'ty',
        -- Python (formatter)
        'ruff',
        -- Swift (type checker)
        'sourcekit',
        -- Go (type checker)
        'gopls',
      })
    end,
  },
  -- }}}

  -- {{{ Surround editing
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end
  },
  -- }}}

  -- {{{ Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'javascript',
          'lua',
          'rust',
          'python',
          'go',
          'gomod',
          'gowork',
          'gosum',
        },
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
  -- }}}

-- {{{ Disable RTP Plugins
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        '2html_plugin',
        'bugreport',
        'compiler',
        'ftplugin',
        'getscript',
        'getscriptPlugin',
        'gzip',
        'logipat',
        'matchit',
        'netrw',
        'netrwFileHandlers',
        'netrwPlugin',
        'netrwSettings',
        'optwin',
        'rplugin',
        'rrhelper',
        'spellfile_plugin',
        'synmenu',
        'syntax',
        'tar',
        'tarPlugin',
        'tohtml',
        'tutor',
        'vimball',
        'vimballPlugin',
        'zip',
        'zipPlugin',
      },
    },
  },
  checker = { enabled = false },
})
-- }}}

-- }}}

-- {{{ Custom Functions

-- {{{ Better terminal buffers

api.nvim_create_user_command('RmTerms',
  function()
    for _, buf in ipairs(api.nvim_list_bufs()) do
      if api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
        api.nvim_buf_delete(buf, { force = true })
      end
    end
  end, {})

-- }}}

-- {{{ Resize vim automatically

api.nvim_create_autocmd('VimResized', {
  callback = function()
    cmd('wincmd =')
  end,
})

-- }}}

-- {{{ Oil

local function open_oil_vsplit(path)
  vim.cmd('vsplit')
  if path then
    require('oil').open(path)
  else
    require('oil').open()
  end
end

-- Open Oil in a horizontal split
local function open_oil_split(path)
  vim.cmd('split')
  if path then
    require('oil').open(path)
  else
    require('oil').open()
  end
end

-- Open Oil in Downloads directory in a horizontal split
local function open_oil_downloads_split()
  local home = vim.fn.expand('~')
  local downloads = home .. '/Downloads'
  open_oil_split(downloads)
end

-- }}}

-- {{{ Go formatting

api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end
})

-- }}}

-- }}}

-- {{{ Keymaps

local diag = vim.diagnostic
local lsp = vim.lsp.buf
local map = vim.keymap.set
local opts = { noremap = true, silent = false }
local silent_opts = { noremap = true, silent = true }

map({ 'n' }, '-', ':Oil<CR>', silent_opts)
map({ 'n' }, '<leader>Q', ':qa!<CR>', silent_opts)
map({ 'n' }, '<leader>ca', lsp.code_action, silent_opts)
map({ 'n' }, '<leader>cd', diag.open_float, silent_opts)
map({ 'n' }, '<leader>fo', lsp.format, silent_opts)
map({ 'n' }, '<leader>gd', lsp.definition, silent_opts)
map({ 'n' }, '<leader>gf', diag.setqflist, silent_opts)
map({ 'n' }, '<leader>gh', lsp.hover, silent_opts)
map({ 'n' }, '<leader>gl', lsp.declaration, silent_opts)
map({ 'n' }, '<leader>gn', diag.goto_next, silent_opts)
map({ 'n' }, '<leader>go', lsp.document_symbol, silent_opts)
map({ 'n' }, '<leader>gp', diag.goto_prev, silent_opts)
map({ 'n' }, '<leader>gr', lsp.references, silent_opts)
map({ 'n' }, '<leader>gg', ':<C-u>!git ', opts)
map({ 'n' }, '<leader>la', ':Lazy<CR>', silent_opts)
map({ 'n' }, '<leader>nh', ':noh<CR>', silent_opts)
map({ 'n' }, '<leader>q', ':q!<CR>', silent_opts)
map({ 'n' }, '<leader>rm', ':RmTerms<CR>', silent_opts)
map({ 'n' }, '<leader>rn', lsp.rename, silent_opts)
map({ 'n' }, '<leader>t', ':<C-u>term ', opts)
map({ 'n' }, '<leader>w', ':w<CR>', silent_opts)
map({ 'n' }, 'j', 'gj', silent_opts)
map({ 'n' }, 'k', 'gk', silent_opts)
map({ 'n', 'v' }, '<leader>p', '"+p', silent_opts)
map({ 'n', 'v' }, '<leader>y', '"+y', silent_opts)
map({ 'n' }, '<leader>ov', open_oil_vsplit, silent_opts)
map({ 'n' }, '<leader>oh', open_oil_split, silent_opts)
map({ 'n' }, '<leader>od', open_oil_downloads_split, silent_opts)
map({ 't' }, '<Esc>', '<C-\\><C-n>', silent_opts)

--: }}}
