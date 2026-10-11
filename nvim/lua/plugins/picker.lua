return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true, ignored = true },
        explorer = { hidden = true, ignored = true },
      },
    },
    bigfile = {
      size = 100 * 1024 * 1024, -- 100MB threshold
      line_length = 100000, -- don't treat minified files (long single lines) as bigfiles
    },
  },
}
