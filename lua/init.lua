
require('telescope').setup {
	file_ignore_patterns = { "^node_modules/", ".cache", "%.o", "%.a", "%.exe", "%.out", "%.class", "%.dll", "%.pdf", "%.mkv", "%.mp4", "%.zip" }
}

-- akinsho/bufferline.nvim
require("bufferline").setup{}

-- gen470/SmoothCursor.nvim
require('smoothcursor').setup({
  autostart = true,
  cursor = "", -- Unicode-Cursor
  texthl = "SmoothCursor",
  linehl = nil,
  type = "default",
})

