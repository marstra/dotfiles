-- Bootstrap lazy.nvim (auto-clones it on first launch if missing).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "ErrorMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim core — provides all defaults, LSP, completion, UI
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- ── LazyVim extras ("layers") ────────────────────────────────────────────
    -- These MUST come after lazyvim.plugins and BEFORE { import = "plugins" }.
    -- LazyVim enforces this order — see lazyvim.config.init "Check lazy.nvim import order".
    -- To add/remove a layer: comment/uncomment here, then :Lazy sync.
    -- Full list: https://www.lazyvim.org/extras

    -- Languages
    { import = "lazyvim.plugins.extras.lang.java" },       -- nvim-jdtls, DAP, test runner
    { import = "lazyvim.plugins.extras.lang.typescript" },  -- ts_ls, prettier, eslint
    { import = "lazyvim.plugins.extras.lang.angular" },     -- @angular/language-server
    { import = "lazyvim.plugins.extras.lang.git" },         -- git commit/rebase/ignore filetypes

    -- AI
    { import = "lazyvim.plugins.extras.ai.copilot" },       -- copilot.lua (inline autocomplete)
    { import = "lazyvim.plugins.extras.ai.copilot-chat" },  -- CopilotChat.nvim (chat panel)

    -- GitHub integration
    { import = "lazyvim.plugins.extras.util.octo" },        -- octo.nvim (PR/issue review)

    -- ── Your own plugins ─────────────────────────────────────────────────────
    -- lua/plugins/*.lua — overrides, additions, colorscheme, git tools, …
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always latest git commit, not semver tags
  },
  install = {
    -- Try these colorschemes when installing for the first time
    colorscheme = { "gruvbox", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,  -- check for updates in background
    notify = false,  -- don't nag — run :Lazy to see pending updates
  },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
