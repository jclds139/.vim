local has_fzf, _ = pcall(require, "fzf-lua")

vim.g.diffs = {
	integrations = {
		fugutive = true,
		fzf_lua = has_fzf,
		difftastic = vim.fn.executable("difft") == 1,
	}

}

vim.cmd("silent! packadd diffs.nvim")
