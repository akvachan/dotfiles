--: {{{ Basic Settings

-- Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General
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
opt.foldlevel = 99        -- Open all folds by default
opt.updatetime = 100      -- Reduce update time for responsiveness
opt.splitbelow = true     -- Horizontal splits open below
opt.splitright = true     -- Vertical splits open to the right
opt.signcolumn = 'yes'    -- Always show the sign column
opt.backup = false        -- Disable backup files
opt.writebackup = false   -- Disable backup before overwriting files
opt.undofile = true       -- Enable persistent undo

-- Disable unused built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- }}}

--: {{{ Plugin Management

-- Lazy.nvim setup
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
  -- Mason for managing LSP servers
  {
    "williamboman/mason.nvim",
    lazy = true,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason LSPConfig for managing LSP integrations
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    lazy = true,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "clangd", "ts_ls" },
        automatic_installation = true,
      })
    end,
  },

  -- Neovim LSP configurations
  { "neovim/nvim-lspconfig", lazy = true },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              require("luasnip").expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    lazy = true,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    config = function()
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { "%.git/", "node_modules", "vendor" },
        },
      })
    end,
  },

  -- Auto Pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Color Theme
  {
    "xiantang/darcula-dark.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme darcula-dark]])
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vimdoc", "javascript", "typescript", "c", "lua", "rust",
          "jsdoc", "bash",
        },

        sync_install = false,
        auto_install = false,
        indent = { enable = true },

        highlight = {
          enable = true,
          disable = function(lang, buf)
            if lang == "html" then
              print("disabled")
              return true
            end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.notify(
                "File larger than 100KB: Treesitter disabled for performance",
                vim.log.levels.WARN,
                { title = "Treesitter" }
              )
              return true
            end
          end,
          additional_vim_regex_highlighting = { "markdown" },
        },
      })

      local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      treesitter_parser_config.templ = {
        install_info = {
          url = "https://github.com/vrischmann/tree-sitter-templ.git",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "master",
        },
      }

      vim.treesitter.language.register("templ", "templ")
    end,
  },

})

-- }}}

--: {{{ LSP Configuration

local lspconfig = require("lspconfig")
local on_attach = function(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
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
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
end

require("mason-lspconfig").setup_handlers({
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    }

    if server_name == "lua_ls" then
      opts.settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry = { enable = false },
        },
      }
    end

    lspconfig[server_name].setup(opts)
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
})

-- }}}

--: {{{ Keybindings

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>lg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bu', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bf', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>mm', '<cmd>Telescope keymaps<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cm', '<cmd>Telescope cmdline<CR>', { noremap = true, silent = true })
vim.keymap.set('n', ';', ':', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', ':wq<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>Q', ':q!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>h', ':noh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<up>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<down>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<left>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<right>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'j', 'gjzz', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gkzz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '}', '}zz', { noremap = true, silent = true })
vim.keymap.set('n', '{', '{zz', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>co', ':copen<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cc', ':cclose<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cn', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cp', ':cprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<', '<<', { noremap = true, silent = true })
vim.keymap.set('n', '>', '>>', { noremap = true, silent = true })
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- }}}
