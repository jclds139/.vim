vim.cmd("silent! packadd nvim-web-devicons")
vim.cmd("silent! packadd fzf-lua")

local success, fzf_lua = pcall(require, "fzf-lua")

if not success then
	goto skip
end

fzf_lua.setup({'ivy', 'skim'})

fzf_lua.register_ui_select()


::skip::
