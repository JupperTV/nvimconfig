
-- nvim-telescope/telescope.nvim
require('telescope').setup {
	file_ignore_patterns = { "^node_modules/", ".cache", "%.o", "%.a", "%.exe", "%.out", "%.class", "%.dll", "%.pdf", "%.mkv", "%.mp4", "%.zip", "%.otf", "%.ttf" }
}

-- akinsho/bufferline.nvim
require("bufferline").setup{}

-- sphamba/smear-cursor.nvim
require('smear_cursor').enabled = true
