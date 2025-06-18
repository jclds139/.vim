require 'nvim-treesitter'.setup {
	-- Directory to install parsers and queries to
	install_dir = vim.fn.stdpath('data') .. '/site'
}

require 'nvim-treesitter'.install({
	"vim",
	"vimdoc",
	"query",
	"python",
	"json",
	"markdown",
	"markdown_inline",
	"bash",
	"gitcommit",
	"comment",
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter" }, {
	callback = function()
		local ts_lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		pcall(require'nvim-treesitter'.install, ts_lang)
		if pcall(vim.treesitter.start, 0) then
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
