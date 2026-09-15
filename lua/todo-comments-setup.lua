vim.cmd("silent! packadd todo-comments")
local success, todo_comments = pcall(require, "todo-comments")

if success then
	todo_comments.setup()
end
