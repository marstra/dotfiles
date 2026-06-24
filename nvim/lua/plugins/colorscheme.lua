-- ─────────────────────────────────────────────────────────────────────────────
-- Colorscheme
-- Using gruvbox — carried over from your .vimrc. The Lua port (ellisonleao/gruvbox.nvim)
-- has full treesitter + LSP highlight support unlike the old VimScript version.
--
-- To switch theme: change the colorscheme value at the bottom to e.g. "tokyonight"
-- (LazyVim's default — better plugin integration but different aesthetics).
-- ─────────────────────────────────────────────────────────────────────────────

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard",          -- "hard" | "soft" | "" (medium)
      transparent_mode = false,
      italic = {
        strings   = true,
        emphasis  = true,
        comments  = true,
        operators = false,
        folds     = true,
      },
      overrides = {
        -- Make the sign column (git/diagnostic icons) blend with the background
        SignColumn = { bg = "NONE" },
      },
    },
  },

  -- Tell LazyVim to activate gruvbox instead of its tokyonight default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
