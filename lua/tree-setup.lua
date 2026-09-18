vim.cmd("silent! packadd nvim-web-devicons")
vim.cmd("silent! packadd netrw.nvim")

local success, netrw = pcall(require, "netrw")

if success then
	netrw.setup({
		use_devicons = true,
	})
end
