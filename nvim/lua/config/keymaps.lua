-- ─────────────────────────────────────────────────────────────────────────────
-- Keymaps
-- LazyVim ships a rich set of defaults (see :help lazyvim-keymaps or press
-- <leader> and watch which-key). Only add what LazyVim doesn't already cover.
-- ─────────────────────────────────────────────────────────────────────────────

local map = vim.keymap.set

-- Explicit clipboard registers (carried over from .vimrc).
-- With clipboard=unnamedplus these are mostly redundant, but muscle memory
-- is valuable — keep them for cross-register yanks.
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank → system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste ← system clipboard" })

-- Exit terminal mode with double-Esc.
-- Useful inside the lazygit/snacks terminal that opens with <leader>gg.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Clear search highlight with Esc in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
