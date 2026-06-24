-- ─────────────────────────────────────────────────────────────────────────────
-- Options
-- Carried over from .vimrc + sensible neovim additions.
-- LazyVim sets many sane defaults already; only override what you care about.
-- ─────────────────────────────────────────────────────────────────────────────

local opt = vim.opt

-- Search
opt.ignorecase = true   -- case-insensitive search …
opt.smartcase = true    -- … unless you type an uppercase letter
opt.incsearch = true    -- show matches as you type
opt.hlsearch = true     -- highlight all matches (clear with <Esc>)
opt.gdefault = true     -- :s///g by default (no need to append g)

-- Appearance
opt.number = true
opt.relativenumber = true  -- relative + absolute hybrid (best of both worlds)
opt.cursorline = true
opt.title = true           -- show filename in terminal title bar
opt.termguicolors = true
opt.signcolumn = "yes"     -- always show sign column (no layout shift on git signs)
opt.showmode = false       -- mode shown in lualine statusline instead
opt.scrolloff = 8          -- always keep 8 lines above/below cursor
opt.sidescrolloff = 8
opt.wrap = false

-- Editing
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true       -- spaces not tabs
opt.smartindent = true
opt.undofile = true        -- persistent undo — survives buffer close and nvim restarts

-- UI behaviour
opt.splitbelow = true      -- :split opens below
opt.splitright = true      -- :vsplit opens right
opt.updatetime = 200       -- faster CursorHold (gitsigns, LSP hover)
opt.timeoutlen = 300       -- which-key popup delay (ms)
opt.conceallevel = 2       -- for markdown, org etc.

-- Clipboard: use system clipboard by default.
-- In WSL2 this relies on win32yank.exe being in PATH (see README).
opt.clipboard = "unnamedplus"

-- Disable error bells
opt.errorbells = false
