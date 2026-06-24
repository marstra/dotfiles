-- ─────────────────────────────────────────────────────────────────────────────
-- Git plugins: diffview.nvim + neogit
--
-- These complement what LazyVim already ships:
--   gitsigns.nvim  — hunk signs in gutter, blame, stage single hunks (<leader>hs)
--   lazygit        — full TUI via snacks.nvim (<leader>gg)  ← daily driver
--
-- diffview: best-in-class diff/history viewer (replaces the VSCode diff tab)
-- neogit:   Magit clone for commit crafting if you prefer the Magit UX
-- ─────────────────────────────────────────────────────────────────────────────

return {

  -- ── diffview.nvim ──────────────────────────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    keys = {
      -- Review working-tree changes (what Copilot CLI just generated)
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",            desc = "Diff: working tree vs HEAD" },
      -- Full repo commit history with inline diffs
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>",     desc = "Diff: repo history" },
      -- History for the current file only
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>",   desc = "Diff: file history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default        = { layout = "diff2_horizontal" },
        -- 3-way merge tool layout — shows LOCAL / BASE / REMOTE
        merge_tool     = { layout = "diff3_horizontal", disable_diagnostics = true },
        file_history   = { layout = "diff2_horizontal" },
      },
      file_panel = {
        listing_style = "tree",
        win_config    = { width = 35 },
      },
      hooks = {
        -- Disable folding inside diff buffers (confusing when reviewing)
        diff_buf_read = function()
          vim.opt_local.foldenable = false
        end,
      },
    },
  },

  -- ── neogit ─────────────────────────────────────────────────────────────────
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",  -- use diffview for all diffs inside neogit
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit (Magit)" },
    },
    opts = {
      integrations = {
        diffview = true,  -- press <Enter> on a file → opens in diffview
      },
      graph_style = "unicode",
      -- Keep it close to Magit defaults
      commit_editor = {
        kind = "auto",
        show_staged_diff = true,
      },
    },
  },
}
