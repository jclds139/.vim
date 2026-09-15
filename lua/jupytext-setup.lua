vim.cmd("silent! packadd jupytext")
local success, jupytext = pcall(require, "jupytext")

if success then
	jupytext.setup({
		autosync = true,
		handle_url_schemes = true,
		update = true,
		format = 'auto',
	})
end
