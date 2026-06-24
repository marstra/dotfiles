-- ─────────────────────────────────────────────────────────────────────────────
-- Autocmds
-- LazyVim handles the common ones (highlight on yank, resize splits, etc.).
-- Add project- or filetype-specific autocmds here as needed.
-- ─────────────────────────────────────────────────────────────────────────────

local autocmd = vim.api.nvim_create_autocmd

-- Java: use 4-space indent (Spring Boot convention)
autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Close certain utility buffers with just `q`
autocmd("FileType", {
  pattern = { "help", "man", "qf", "checkhealth" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
  end,
})
