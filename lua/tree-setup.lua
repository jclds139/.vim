vim.cmd("silent! packadd nvim-web-devicons")
vim.cmd("silent! packadd nvim-tree.lua")

local success, nvim_tree = pcall(require, "nvim-tree")

if success then
	nvim_tree.setup()
end
