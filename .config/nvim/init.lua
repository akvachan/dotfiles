# vim:fileencoding=utf-8:foldmethod=marker

-- {{{ Basic Settings

local g, opt, cmd, fn, api, lsp = vim.g, vim.opt, vim.cmd, vim.fn, vim.api, vim.lsp
opt.autoindent                  = true
opt.completeopt                 = { "menuone", "noselect", "noinsert" }
opt.pumheight                   = 10
opt.background                  = 'dark'
opt.backup                      = false
opt.equalalways                 = true
opt.expandtab                   = true
opt.foldenable                  = true
opt.grepformat                  = '%f:%l:%c:%m,%f:%l:%m'
opt.grepprg                     = 'rg --vimgrep --no-heading --smart-case'
opt.hlsearch                    = true
opt.ignorecase                  = true
opt.incsearch                   = true
opt.lazyredraw                  = true
opt.mouse                       = 'a'
opt.number                      = true
opt.relativenumber              = true
opt.shiftwidth                  = 2
opt.signcolumn                  = 'yes'
opt.smartcase                   = true
opt.splitbelow                  = true
opt.splitright                  = true
opt.swapfile                    = false
opt.tabstop                     = 2
opt.termguicolors               = true
opt.updatetime                  = 100
opt.wrap                        = false
opt.writebackup                 = false
opt.winborder                   = "rounded"
g.mapleader                     = ' '
g.maplocalleader                = ' '
g.matchparen_insert_timeout     = 20
g.matchparen_timeout            = 20

-- }}}

-- {{{ LSP

-- {{{ Lua
lsp.config['lua_ls']            = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        }
      }
    }
  },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
lsp.enable('lua_ls')
-- }}}

-- {{{ Go
lsp.config['gopls'] = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        }
      }
    }
  },
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}
lsp.enable('gopls')
-- }}}

-- {{{ Python (ty)
lsp.config['ty'] = {
  cmd = { 'ty', 'server' },
  filetypes = { 'python', 'pyproject.toml' },
  root_markers = { '.git', 'pyproject.toml', },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        }
      }
    }
  }
}
lsp.enable('ty')

lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python', 'pyproject.toml' },
  root_markers = { '.git', 'pyproject.toml', },
})

lsp.enable('ruff')
-- }}}

-- {{{ Rust
lsp.config['rust_analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        }
      }
    }
  },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = 'clippy',
      },
    },
  },
}
lsp.enable('rust_analyzer')
-- }}}

-- {{{ Swift
lsp.config['sourcekit'] = {
  cmd = { 'sourcekit-lsp' },
  filetypes = { 'swift' },
  root_markers = {
    'Package.swift',
    'buildServer.json',
    '*.xcworkspace',
    '*.xcodeproj',
    '.git',
  },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        }
      }
    }
  }
}
lsp.enable('sourcekit')
-- }}}

-- {{{ C / C++
lsp.config['clangd'] = {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = {
    'compile_commands.json',
    'compile_flags.txt',
    '.git',
  },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = false,
        }
      }
    }
  }
}
lsp.enable('clangd')
-- }}}

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

  -- {{{ Autopair
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
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
              fn.setreg('+', fn.getreg(vim.v.register))
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
              local relpath = fn.fnamemodify(dir, ':.')
              fn.setreg('+', relpath .. entry.name)
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
      { '<leader>ff', function() require('fzf-lua').files() end,                desc = 'Find files' },
      { '<leader>fg', function() require('fzf-lua').live_grep() end,            desc = 'Live grep' },
      { '<leader>fb', function() require('fzf-lua').buffers() end,              desc = 'Buffers' },
      { '<leader>fl', function() require('fzf-lua').blines() end,               desc = 'Current buffer lines' },
      { '<leader>fr', function() require('fzf-lua').resume() end,               desc = 'Resume work' },
      { '<leader>sd', function() require('fzf-lua').lsp_document_symbols() end, desc = 'Symbols (document)' },
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
              fn.setreg("+", path)
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

  -- {{{ Surround editing
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup()
    end
  },
  -- }}}

  -- {{{ Xcodebuild
  {
    "wojciech-kulik/xcodebuild.nvim",
    event = "VeryLazy",
    dependencies = {
      "ibhagwan/fzf-lua",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("xcodebuild").setup({})
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

-- {{{ Completion
api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/completion') then
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = false,
      })
    end

    api.nvim_buf_set_option(args.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
})
-- }}}

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
  cmd('vsplit')
  if path then
    require('oil').open(path)
  else
    require('oil').open()
  end
end

-- Open Oil in a horizontal split
local function open_oil_split(path)
  cmd('split')
  if path then
    require('oil').open(path)
  else
    require('oil').open()
  end
end

-- Open Oil in Downloads directory in a horizontal split
local function open_oil_downloads_split()
  local home = fn.expand('~')
  local downloads = home .. '/Downloads'
  open_oil_split(downloads)
end
-- }}}

-- {{{ Insert time
local function insert_time()
  local timestamp = os.date("%d%m%y-%H%M%S")
  api.nvim_put({ timestamp }, "c", true, true)
end
-- }}}

-- {{{ Open file with template
local function open_file_with_template()
  local file = fn.expand('<cfile>')
  cmd('edit ' .. file)

  -- Insert template only if file is empty
  if fn.line('$') == 1 and fn.getline(1) == '' then
    local date = os.date('%Y-%m-%d')
    local title = fn.fnamemodify(file, ':t:r')

    api.nvim_buf_set_lines(0, 0, -1, false, {
      '---',
      'date: "' .. date .. '"',
      'tags:',
      'status: Active',
      '---',
      '',
      '# ' .. title,
      '',
      '## Description',
      ''
    })

    cmd('normal! G')
  end
end
-- }}}

-- }}}

-- {{{ Keymaps

local diag = vim.diagnostic
local buf = lsp.buf
local map = vim.keymap.set
local opts = { noremap = true, silent = false }
local silent_opts = { noremap = true, silent = true }

map({ 'n' }, '-', ':Oil<CR>', silent_opts)
map({ 'n' }, '<leader>ca', buf.code_action, silent_opts)
map({ 'n' }, '<leader>cd', diag.open_float, silent_opts)
map({ 'n' }, '<leader>fo', buf.format, silent_opts)
map({ 'n' }, '<leader>gd', buf.definition, silent_opts)
map({ 'n' }, '<leader>gf', diag.setqflist, silent_opts)
map({ 'n' }, '<leader>gg', ':<C-u>!git ', opts)
map({ 'n' }, '<leader>gh', buf.hover, silent_opts)
map({ 'n' }, '<leader>gl', buf.declaration, silent_opts)
map({ 'n' }, '<leader>gn', diag.goto_next, silent_opts)
map({ 'n' }, '<leader>go', buf.document_symbol, silent_opts)
map({ 'n' }, '<leader>gp', diag.goto_prev, silent_opts)
map({ 'n' }, '<leader>gr', buf.references, silent_opts)
map({ 'n' }, '<leader>it', insert_time, silent_opts)
map({ 'n' }, '<leader>la', ':Lazy<CR>', silent_opts)
map({ 'n' }, '<leader>od', open_oil_downloads_split, silent_opts)
map({ 'n' }, '<leader>of', open_file_with_template, silent_opts)
map({ 'n' }, '<leader>oh', open_oil_split, silent_opts)
map({ 'n' }, '<leader>ov', open_oil_vsplit, silent_opts)
map({ 'n' }, '<leader>q', ':q!<CR>', silent_opts)
map({ 'n' }, '<leader>rm', ':RmTerms<CR>', silent_opts)
map({ 'n' }, '<leader>rn', buf.rename, silent_opts)
map({ 'n' }, '<leader>t', ':<C-u>te ', opts)
map({ 'n' }, '<leader>w', ':w!<CR>', silent_opts)
map({ 'n', 'v' }, '<leader>p', '"+p', silent_opts)
map({ 'n', 'v' }, '<leader>y', '"+y', silent_opts)
map({ 't' }, '<Esc>', '<C-\\><C-n>', silent_opts)

--: }}}
