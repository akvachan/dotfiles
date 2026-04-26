# vim:fileencoding=utf-8:foldmethod=marker

-- {{{ Basic settings

vim.loader.enable()

vim.g.mapleader                 = ' '
vim.g.maplocalleader            = ' '
vim.g.matchparen_insert_timeout = 20
vim.g.matchparen_timeout        = 20
vim.opt.background              = 'dark'
vim.opt.backup                  = false
vim.opt.clipboard               = 'unnamedplus'
vim.opt.completeopt             = { "menuone", "noselect", "noinsert" }
vim.opt.colorcolumn             = '80'
vim.opt.confirm                 = true
vim.opt.equalalways             = true
vim.opt.expandtab               = true
vim.opt.foldenable              = true
vim.opt.grepformat              = '%f:%l:%c:%m,%f:%l:%m'
vim.opt.grepprg                 = 'rg --vimgrep --no-heading --smart-case'
vim.opt.ignorecase              = true
vim.opt.number                  = true
vim.opt.pumheight               = 10
vim.opt.relativenumber          = true
vim.opt.scrolloff               = 20
vim.opt.shiftwidth              = 2
vim.opt.signcolumn              = 'yes'
vim.opt.smartcase               = true
vim.opt.smartindent             = true
vim.opt.splitbelow              = true
vim.opt.splitright              = true
vim.opt.swapfile                = false
vim.opt.tabstop                 = 2
vim.opt.updatetime              = 100
vim.opt.winborder               = "rounded"
vim.opt.wrap                    = false
vim.opt.writebackup             = false

-- }}}

-- {{{ LSP

-- {{{ Lua

local no_snippets               = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = false,
      }
    }
  }
}

vim.lsp.config['lua_ls']        = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  capabilities = no_snippets,
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
vim.lsp.enable('lua_ls')

-- }}}

-- {{{ Go

vim.lsp.config['gopls'] = {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  capabilities = no_snippets,
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
vim.lsp.enable('gopls')

-- }}}

-- {{{ Python (ty)

vim.lsp.config['ty'] = {
  cmd = { 'ty', 'server' },
  filetypes = { 'python', 'pyproject.toml' },
  root_markers = { '.git', 'pyproject.toml', },
  capabilities = no_snippets,
}
vim.lsp.enable('ty')

vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python', 'pyproject.toml' },
  root_markers = { '.git', 'pyproject.toml', },
})
vim.lsp.enable('ruff')

-- }}}

-- {{{ Rust

vim.lsp.config['rust_analyzer'] = {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  capabilities = no_snippets,
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
vim.lsp.enable('rust_analyzer')

-- }}}

-- {{{ Typescript

vim.lsp.config['tsserver'] = {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = {
    'vim.package.json',
    'tsconfig.json',
    'jsconfig.json',
    '.git',
  },
  capabilities = no_snippets,
}
vim.lsp.enable('tsserver')

-- }}}

-- {{{ C / C++

vim.lsp.config['clangd'] = {
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
    },
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }
}
vim.lsp.enable('clangd')

-- }}}

-- }}}

-- {{{ Plugins

-- {{{ Autopair

vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })
vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require('nvim-autopairs').setup()
  end,
})

-- }}}

-- {{{ Treesitter
local ts_filetypes = {
  'lua',
  'python',
  'javascript',
  'typescript',
  'rust',
  'c',
  'swift',
  'markdown',
  'go',
  'yaml',
  'dockerfile'
}

vim.pack.add({
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    version = 'main',
  },
})
require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}
require('nvim-treesitter').install(ts_filetypes)
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_filetypes,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
vim.g.no_plugin_maps = true
local ts = require("nvim-treesitter-textobjects")
ts.setup {
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"]   = "v",
      ["@parameter.inner"]   = "v",
      ["@assignment.inner"]  = "v",
      ["@conditional.inner"] = "v",
      ["@comment.inner"]     = "v",
      ["@function.outer"]    = "v",
      ["@function.inner"]    = "v",
      ["@class.outer"]       = "v",
      ["@class.inner"]       = "v",
      ["@assignment.outer"]  = "v",
      ["@conditional.outer"] = "v",
      ["@loop.outer"]        = "v",
      ["@loop.inner"]        = "v",
      ["@comment.outer"]     = "v",
    },
    include_surrounding_whitespace = false,
  },
  move = { set_jumps = true },
}
local select  = require("nvim-treesitter-textobjects.select")
local move    = require("nvim-treesitter-textobjects.move")
local swap    = require("nvim-treesitter-textobjects.swap")
local objects = {
  f = "function",
  c = "class",
  a = "parameter",
  v = "assignment",
  i = "conditional",
  l = "loop",
  ["/"] = "comment",
}
for key, obj in pairs(objects) do
  -- Selection
  vim.keymap.set({ "x", "o" }, "a" .. key, function()
    select.select_textobject("@" .. obj .. ".outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "i" .. key, function()
    select.select_textobject("@" .. obj .. ".inner", "textobjects")
  end)
  -- Goto
  local goto_variant = (obj == "parameter") and ".inner" or ".outer"
  vim.keymap.set({ "n", "x", "o" }, "]" .. key, function()
    move.goto_next_start("@" .. obj .. goto_variant, "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[" .. key, function()
    move.goto_previous_start("@" .. obj .. goto_variant, "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]" .. key:upper(), function()
    move.goto_next_end("@" .. obj .. ".outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[" .. key:upper(), function()
    move.goto_previous_end("@" .. obj .. ".outer", "textobjects")
  end)
end
-- Swap
vim.keymap.set("n", "<leader>a", function()
  swap.swap_next("@parameter.inner")
end)
vim.keymap.set("n", "<leader>A", function()
  swap.swap_previous("@parameter.inner")
end)

-- }}}

-- {{{ File explorer

vim.pack.add({ 'https://github.com/stevearc/oil.nvim' })
require('oil').setup({
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
        local entry = require('oil').get_cursor_entry()
        local dir = require('oil').get_current_dir()
        if not entry or not dir then
          return
        end
        local relpath = vim.fn.fnamemodify(dir, ':.')
        vim.fn.setreg('+', relpath .. entry.name)
      end,
    },
    -- Discard all filesystem changes
    ['<leader>oc'] = require('oil').discard_all_changes,
  },
})

-- }}}

-- {{{ Fuzzy finder

vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })
require('fzf-lua').setup({
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
    cmd = [[
    rg --column --color=never --no-heading --line-number --hidden --smart-case
    ]],
  },
  keymap = {
    fzf = {
      -- Send selection to quickfix list
      ['ctrl-q'] = 'select-all+accept',
    },
  },
})

-- }}}

-- {{{ Surround editing

vim.pack.add({ 'https://github.com/kylechui/nvim-surround' })
require('nvim-surround').setup()

-- }}}

-- }}}

-- {{{ Custom functions

-- {{{ Completion

vim.api.nvim_create_autocmd('vim.lspAttach', {
  group = vim.api.nvim_create_augroup('my.vim.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end

    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.vim.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = args.buf,
            id = client.id,
            timeout_ms = 1000,
          })
        end,
      })
    end
  end,
})

-- }}}

-- {{{ Better terminal buffers

vim.api.nvim_create_user_command('RmTerms',
  function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == 'terminal' then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end, {})

-- }}}

-- {{{ Resize vim automatically

vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd('wincmd =')
  end,
})

-- }}}

-- {{{ Oil

local function open_oil_vsplit(path)
  vim.cmd('vsplit')
  if path then
    require('oil').open(path)
  else
    require('oil').open(vim.fn.getcwd())
  end
end

-- Open Oil in a horizontal split
local function open_oil_split(path)
  vim.cmd('split')
  if path then
    require('oil').open(path)
  else
    require('oil').open(vim.fn.getcwd())
  end
end

-- Open Oil in Downloads directory in a horizontal split
local function open_oil_downloads_split()
  local home = vim.fn.expand('~')
  local downloads = home .. '/Downloads'
  open_oil_split(downloads)
end

-- }}}

-- }}}

-- {{{ Keymaps

local opts = { noremap = true, silent = false }
local silent_opts = { noremap = true, silent = true }

vim.keymap.set('n', '-', '<cmd>Oil<CR>', silent_opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, silent_opts)
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, silent_opts)
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, silent_opts)
vim.keymap.set('n', '<leader>gf', vim.diagnostic.setqflist, silent_opts)
vim.keymap.set('n', '<leader>gg', ':<C-u>!git ', opts)
vim.keymap.set('n', '<leader>gl', vim.lsp.buf.declaration, silent_opts)
vim.keymap.set('n', '<leader>go', vim.lsp.buf.document_symbol, silent_opts)
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, silent_opts)
vim.keymap.set('n', '<leader>od', open_oil_downloads_split, silent_opts)
vim.keymap.set('n', '<leader>oh', open_oil_split, silent_opts)
vim.keymap.set('n', '<leader>ov', open_oil_vsplit, silent_opts)
vim.keymap.set('n', '<leader>q', '<cmd>q!<CR>', silent_opts)
vim.keymap.set('n', '<leader>rm', '<cmd>RmTerms<CR>', silent_opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, silent_opts)
vim.keymap.set('n', '<leader>t', ':<C-u>te ', opts)
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', silent_opts)
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', silent_opts)
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', silent_opts)
vim.keymap.set({ 't' }, '<Esc>', '<C-\\><C-n>', silent_opts)


vim.keymap.set('n', '<leader>ff', function()
  require('fzf-lua').files()
end, silent_opts)

vim.keymap.set('n', '<leader>fg', function()
  require('fzf-lua').live_grep()
end, silent_opts)

vim.keymap.set('n', '<leader>fb', function()
  require('fzf-lua').buffers()
end, silent_opts)

vim.keymap.set('n', '<leader>fl', function()
  require('fzf-lua').blines()
end, silent_opts)

vim.keymap.set('n', '<leader>fr', function()
  require('fzf-lua').resume()
end, silent_opts)

vim.keymap.set('n', '<leader>sd', function()
  require('fzf-lua').vim.lsp_document_symbols()
end, silent_opts)

-- }}}
