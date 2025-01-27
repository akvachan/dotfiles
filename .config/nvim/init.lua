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
opt.synmaxcol = 200
opt.expandtab = true      -- Use spaces instead of tabs
opt.autoindent = true     -- Auto-indent new lines
opt.mouse = 'a'           -- Enable mouse support
opt.wrap = false          -- Disable line wrapping
opt.hlsearch = true       -- Highlight search results
opt.incsearch = true      -- Incremental search
opt.smartcase = true      -- Smart case sensitivity for search
opt.ignorecase = true     -- Ignore case
opt.termguicolors = true  -- Enable 24-bit color
opt.foldmethod = 'marker' -- Use markers for folding
opt.foldenable = true     -- Enable folding
opt.foldlevel = 99        -- Open all folds by default
opt.updatetime = 50       -- Reduce update time for responsiveness
opt.splitbelow = true     -- Horizontal splits open below
opt.splitright = true     -- Vertical splits open to the right
opt.signcolumn = 'yes'    -- Always show the sign column
vim.opt.swapfile = false  -- Disable swap files
opt.backup = false        -- Disable backup files
opt.writebackup = false   -- Disable backup before overwriting files
opt.undofile = true       -- Enable persistent undo
opt.background = 'dark'   -- Set background to dark

local disabled_built_ins = {
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'matchit',
  'matchparen',
  'logiPat',
  'rrhelper',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

-- }}}

--: {{{ Autocommands

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    vim.cmd("normal! zz")
  end,
})

-- Store the last executed command
local last_shell_command = nil

-- Function to run a shell command and display output in a new split
local function run_shell_command()
  vim.ui.input({ prompt = "Shell Command: " }, function(input)
    if input and input ~= "" then
      last_shell_command = input
      vim.cmd("new")  -- Open a new horizontal split
      vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted")  -- Set buffer options
      vim.cmd("setlocal nowrap modifiable")  -- Allow text editing and wrapping
      vim.cmd("normal! ggdG")  -- Clear buffer content
      local output = vim.fn.systemlist(input)  -- Capture command output
      vim.api.nvim_buf_set_lines(0, 0, -1, false, output)  -- Set buffer content
      vim.cmd("setlocal nomodifiable")  -- Make buffer read-only after output
    end
  end)
end

-- Function to reopen the last executed command output
local function reopen_last_command()
  if last_shell_command then
    vim.cmd("new")
    vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted")
    vim.cmd("setlocal nowrap modifiable")
    vim.cmd("normal! ggdG")
    local output = vim.fn.systemlist(last_shell_command)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
    vim.cmd("setlocal nomodifiable")
  else
    vim.notify("No previous command executed", vim.log.levels.WARN)
  end
end

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

-- Oil
map("n", "-", "<CMD>Oil<CR>", opts)

-- LSP Keymaps
map('n', 'gd', vim.lsp.buf.definition, opts)             -- Go to definition
map('n', 'gD', vim.lsp.buf.declaration, opts)            -- Go to declaration
map('n', 'gr', vim.lsp.buf.references, opts)             -- List references
map('n', 'gi', vim.lsp.buf.implementation, opts)         -- Go to implementation
map('n', '<leader>rn', vim.lsp.buf.rename, opts)         -- Rename symbol
map('n', '<leader>ca', vim.lsp.buf.code_action, opts)    -- Code actions
map('n', '<leader>bf', vim.lsp.buf.format, opts)         -- Format code
map('n', 'K', vim.lsp.buf.hover, opts)                   -- Hover documentation
map('n', '<leader>sh', vim.lsp.buf.signature_help, opts) -- Signature help
map('n', '<leader>cd', vim.diagnostic.open_float, opts)  -- Show detailed diagnostics in a floating window
map('n', '<leader>gf', vim.diagnostic.setqflist, opts)   -- Send all diagnostics to the quickfix list

-- FZF Keymaps
map('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", opts)     -- Find files
map('n', '<leader>fg', "<cmd>lua require('fzf-lua').live_grep()<CR>", opts) -- Live grep
map('n', '<leader>fb', "<cmd>lua require('fzf-lua').buffers()<CR>", opts)   -- List open buffers
map('n', '<leader>fh', "<cmd>lua require('fzf-lua').help_tags()<CR>", opts) -- Help tags
map('n', '<leader>fo', "<cmd>lua require('fzf-lua').oldfiles()<CR>", opts)  -- Recently opened files

-- Clipboard
map({ 'n', 'v' }, '<leader>y', '"+y', opts)
map({ 'n', 'v' }, '<leader>p', '"+p', opts)

-- Removal
map({ "n", "v" }, "<leader>d", "\"_d") -- Remove without overwriting register content

-- Shell integration
map('n', '!', run_shell_command, { noremap = true, silent = true })
map('n', '<leader>!', reopen_last_command, { noremap = true, silent = true })

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
  { 'ibhagwan/fzf-lua',                  config = function() require('fzf-lua').setup({}) end },
  { 'williamboman/mason.nvim',           event = 'BufReadPre' },
  { 'williamboman/mason-lspconfig.nvim', event = 'BufReadPre' },
  { 'neovim/nvim-lspconfig',             ft = { 'lua', 'typescript', 'python', 'cpp' } },
  { 'stevearc/oil.nvim' },
})

-- }}}

--: {{{ LSP Configuration

local lspconfig = require('lspconfig')

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'ts_ls', 'pylsp', 'clangd' },
  automatic_installation = true,
})
require("oil").setup()

-- Lua
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
    },
  },
})

-- TypeScript
lspconfig.ts_ls.setup({})

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
})

-- C++
lspconfig.clangd.setup({})

-- Disable inline diagnostics
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = false,
  update_in_insert = true,
  severity_sort = true,
})

-- }}}

--: {{{ Colorscheme

vim.cmd('colorscheme habamax')

-- }}}
