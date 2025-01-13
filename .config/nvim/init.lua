--: {{{ Basic Settings

--: {{{ Leader Key

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set('n', '<Space>', '<NOP>', { noremap = true, silent = true })

-- }}}

--: {{{ General

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
opt.foldlevel = 0         -- Start with all folds closed
opt.updatetime = 250      -- Faster update time
opt.splitbelow = true     -- Horizontal splits open below
opt.splitright = true     -- Vertical splits open to the right
opt.termguicolors = true  -- Enable true color support
opt.signcolumn = 'yes'    -- Always show the sign column

-- }}}

-- }}}

--: {{{ Plugins

--: {{{ Lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({

-- }}}

--: {{{ File explorer

  { 'PhilRunninger/nerdtree-visual-selection' },
  { 'preservim/nerdtree' },

-- }}}

--: {{{ Fuzzy finder

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jonarrien/telescope-cmdline.nvim',
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension('cmdline')
    end,
  },

  -- Path utility etc
  { 'nvim-lua/plenary.nvim' },

  -- Command Line Enhancements
  { 'jonarrien/telescope-cmdline.nvim' },

-- }}}

--: {{{ Snippets

  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

-- }}}

--: {{{ LSP

  { 'neovim/nvim-lspconfig' },

  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason LSPconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright" }, -- Add more servers as needed
        automatic_installation = true,
      })
    end,
  },

-- }}}

--: {{{ Autocompletion

  { 'hrsh7th/nvim-cmp',          dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' } },

-- }}}

--: {{{ Git signs

  { 'lewis6991/gitsigns.nvim' },

-- }}}

--: {{{ Status line

  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

--: }}}

--: {{{ Surround text objects

  { 'tpope/vim-surround' },

-- }}}

--: {{{ Auto pairing for brackets etc

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

-- }}}

--: {{{ Visual Increment

  {
    "https://github.com/triglav/vim-visual-increment"
  },

-- }}}

--: {{{ Color Theme

  {
    "xiantang/darcula-dark.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    priority = 1000,                        -- Ensure it loads first
    config = function()
      vim.cmd([[colorscheme darcula-dark]]) -- Apply the theme
    end,
  },
}, {})

-- }}}


-- }}}

--: {{{ Plugins Settings

--: {{{ NERDTree

-- Function to toggle NERDTree in the current directory
local function toggle_nerdtree_in_cur_dir()
  local nerdtree_win_id = nil
  local total_windows = #vim.api.nvim_list_wins()

  -- Iterate through all open windows to find NERDTree
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match("NERD_tree_") then
      nerdtree_win_id = win
      break
    end
  end

  if nerdtree_win_id then
    if total_windows > 1 then
      vim.cmd("NERDTreeClose")
    else
      vim.notify("Cannot close NERDTree, when it is a single buffer open.", vim.log.levels.ERROR)
    end
  else
    vim.cmd("NERDTreeFind")
  end
end

-- Create a command to toggle NERDTree
vim.api.nvim_create_user_command(
  'NERDTreeToggleInCurDir',
  toggle_nerdtree_in_cur_dir,
  {}
)

-- }}}

--: {{{ LuaSnip

require("luasnip.loaders.from_vscode").lazy_load()

-- }}}

--: {{{ Fuzzy finder

local telescope = require('telescope')
telescope.setup {}

-- }}}

--: {{{ Gitsigns

require('gitsigns').setup {}

-- }}}

--: {{{ Lualine

require('lualine').setup {}

-- }}}

--: {{{ LSP

local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

-- Enable diagnostics globally
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
})

-- Common on_attach function for LSP servers
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- LSP Keybindings
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<leader>dd', vim.diagnostic.setqflist, opts)
  vim.keymap.set('n', '<leader>gc', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>gh', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<leader>gl', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>re', ':LspRestart<cr>')
  vim.keymap.set('n', '<leader>df', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, opts)
end

-- Setup handlers for LSP servers
mason_lspconfig.setup_handlers({
  -- Default handler for all servers
  function(server_name)
    local opts = {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    }

    -- Specific settings for lua_ls
    if server_name == "lua_ls" then
      opts.settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }, -- Recognize the 'vim' global
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
            checkThirdParty = false,                           -- Disable annoying third-party notifications
          },
          telemetry = { enable = false },                      -- Disable telemetry for performance
        },
      }
    end

    lspconfig[server_name].setup(opts)
  end,
})

-- }}}

--: Autocompletion {{{

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Using LuaSnip for snippets
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For LuaSnip users
  },
})

-- }}}

-- }}}

--: {{{ Keybindings

--: {{{ NERDTree

vim.keymap.set('n', '<leader>nt', ':NERDTreeToggleInCurDir<CR>', { noremap = true, silent = true })

-- }}}

--: {{{ Telescope

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bu', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bf', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>mm', '<cmd>Telescope keymaps<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cm', '<cmd>Telescope cmdline<CR>', { noremap = true, silent = true })

-- }}}

--: {{{ Command Mode

vim.keymap.set('n', ';', ':', { noremap = true, silent = true })

-- }}}

--: {{{ Quick Saves and Quits

vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', ':wq<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { noremap = true, silent = true })

-- }}}

--: {{{ Clipboard Integration

vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, silent = true }) -- Copy to clipboard
vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, silent = true }) -- Paste from clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, silent = true })

-- }}}

--: {{{ Search

vim.keymap.set('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true }) -- Clear search highlight

-- }}}

--: {{{ Navigation Between Splits

vim.keymap.set('n', '<up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<down>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<left>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<right>', '<C-w>l', { noremap = true, silent = true })

-- }}}

--: {{{ Moving Lines Up and Down

vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- }}}

--: {{{ Center Cursor While Moving

vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'j', 'gjzz', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gkzz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '}', '}zz', { noremap = true, silent = true })
vim.keymap.set('n', '{', '{zz', { noremap = true, silent = true })

-- }}}

--: {{{ Folding

vim.keymap.set('n', '<leader>o', 'za', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>O', 'zM', { noremap = true, silent = true })

-- }}}

--: {{{ Quickfix List

vim.keymap.set('n', '<leader>co', ':copen<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cc', ':cclose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cn', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cp', ':cprevious<CR>', { noremap = true, silent = true })

-- }}}

--: {{{ Toggle Relative Line Numbers

vim.keymap.set('n', '<leader>n', ':set relativenumber!<CR>', { noremap = true, silent = true })

-- }}}

--: {{{ Vertical Movement

vim.keymap.set('n', '<leader>j', 'jS', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', 'kS', { noremap = true, silent = true })

-- }}}

--: Indent Lines Left and Right {{{

vim.keymap.set('n', '>', '>gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Decrease indentation with '<'
vim.keymap.set('n', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })

-- }}}

-- }}}

--: {{{ Lua Scripts

--: Gathering Files {{{

-- Function to gather files with multiple extensions and exclude specific directories
local function gather_files_with_extensions(dir, extensions, exclude_dirs)
  local files = {}

  -- Recursive function to scan directories
  local function scan_dir(path)
    local fd = vim.loop.fs_scandir(path)
    if not fd then return end

    while true do
      local name, type = vim.loop.fs_scandir_next(fd)
      if not name then break end

      local full_path = path .. "/" .. name
      local excluded = false

      -- Check if the directory should be excluded
      for _, exclude in ipairs(exclude_dirs) do
        if full_path:match(vim.pesc(exclude)) then
          excluded = true
          break
        end
      end

      if excluded then
        goto continue
      end

      if type == "directory" then
        scan_dir(full_path) -- Recursively scan subdirectories
      elseif type == "file" then
        for _, ext in ipairs(extensions) do
          if name:match("%." .. ext .. "$") then
            table.insert(files, full_path)
            break
          end
        end
      end
      ::continue::
    end
  end

  scan_dir(dir)
  return files
end

local function write_files_to_buffer(files)
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)

  -- Write file content to the buffer
  for _, file_path in ipairs(files) do
    local file = io.open(file_path, "r")
    if file then
      local content = file:read("*all")
      file:close()

      vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "===" .. file_path .. "===" })
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(content, "\n"))
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "" }) -- Add a blank line
    end
  end
end

local function gather_and_write_files(extensions, exclude_dirs)
  local project_dir = vim.fn.getcwd() -- Current working directory
  local files = gather_files_with_extensions(project_dir, extensions, exclude_dirs)
  if #files > 0 then
    write_files_to_buffer(files)
  else
    print("No files with specified extensions found.")
  end
end

-- Create a user command
vim.api.nvim_create_user_command("GatherFiles", function(opts)
  local args = vim.split(opts.args, " ")
  local extensions = vim.split(args[1], ",") -- First argument is comma-separated extensions
  local exclude_dirs = {}

  if #args > 1 then
    exclude_dirs = vim.split(args[2], ",") -- Second argument is comma-separated directories
  end

  gather_and_write_files(extensions, exclude_dirs)
end, { nargs = "*" })

-- Usage:
-- :GatherFiles <extensions> <exclude_dirs>
-- Example:
-- :GatherFiles lua,txt .git,node_modules

-- }}}

--: Find and Replace in Files with Buffer Reload {{{

local function find_and_replace_in_files(pattern, replacement, extensions, exclude_dirs)
  local files = gather_files_with_extensions(vim.fn.getcwd(), extensions, exclude_dirs)

  if not files or #files == 0 then
    print("No matching files found.")
    return
  end

  for _, file_path in ipairs(files) do
    local file = io.open(file_path, "r")
    if file then
      local content = file:read("*all")
      file:close()

      if content then
        local new_content, substitutions = content:gsub(pattern, replacement)
        if substitutions > 0 then
          local write_file = io.open(file_path, "w")
          if write_file then
            write_file:write(new_content)
            write_file:close()
            print("Updated " .. file_path .. " (" .. substitutions .. " substitutions)")

            -- Reload buffer using checktime
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_get_name(buf) == file_path then
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd("checktime")
                end)
                break
              end
            end
          else
            print("Error: Could not write to " .. file_path)
          end
        end
      else
        print("Error: Could not read content from " .. file_path)
      end
    else
      print("Error: Could not open file " .. file_path)
    end
  end
end

vim.api.nvim_create_user_command("FindReplace", function(opts)
  local args = vim.split(opts.args, " ")
  if #args < 3 then
    print("Usage: :FindReplace <pattern> <replacement> <extensions> [<exclude_dirs>]")
    return
  end

  local pattern = args[1]
  local replacement = args[2]
  local extensions = vim.split(args[3], ",")
  local exclude_dirs = #args > 3 and vim.split(args[4], ",") or {}

  find_and_replace_in_files(pattern, replacement, extensions, exclude_dirs)
end, { nargs = "*" })

-- Usage:
-- :FindReplace <pattern> <replacement> <extensions> [<exclude_dirs>]
-- Example:
-- :FindReplace "oldText" "newText" lua,txt .git,node_modules

-- }}}

--: Word Count {{{

local function count_words()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local text = table.concat(lines, " ")
  local word_count = select(2, text:gsub("%S+", ""))
  print("Word Count: " .. word_count)
end

vim.api.nvim_create_user_command("WordCount", count_words, {})

-- Usage:
-- :WordCount

-- }}}

-- }}}
