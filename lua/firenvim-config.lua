vim.g.firenvim_config = {
	globalSettings = { alt = "all" },
	localSettings = {
		[".*"] = {
			cmdline  = "neovim",
			content  = "text",
			priority = 0,
			selector =
			"textarea:not([readonly]):not([class='handsontableInput']), div[role='textbox'], input",
			takeover = "never"
		},
		[".*notion\\.so.*"] = { priority = 9, takeover = "never" },
		[".*docs\\.google\\.com.*"] = { priority = 9, takeover = "never" }
	}
}

local function firenvim_filetype(args)
	local markdown_site_pattern = "git[a-z]\\{3}\\.com\\|stack\\(exc\\|over\\)\\|slack\\.com\\|reddit.com\\c"
	local jupyter_site_pattern = "co\\(calc\\|.*google.*\\)\\.com\\|kaggle.*\\.com\\c"

	if vim.regex(markdown_site_pattern):match_str(args["file"]) then
		vim.opt.filetype = "markdown"
		vim.opt_local.spell = true
		vim.opt_local.linebreak = true
	elseif vim.regex(jupyter_site_pattern):match_str(args["file"]) then
		vim.opt.filetype = "python"
	elseif vim.regex("localhost\\c"):match_str(args["file"]) then
		vim.opt.filetype = "tiddlywiki"
		vim.opt_local.spell = true
		vim.opt_local.linebreak = true
	end
end

local aug = vim.api.nvim_create_augroup("firenvim", { clear = true })

vim.api.nvim_create_autocmd({ 'UIEnter' }, {
	pattern = "*",
	group = aug,
	callback = function() vim.fn.NvimFont(14) end
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
	pattern = "*",
	group = aug,
	callback = firenvim_filetype
})
