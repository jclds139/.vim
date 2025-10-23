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
	"comment",
})


vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter" }, {
	callback = function()
		local ts_lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		pcall(require 'nvim-treesitter'.install, ts_lang)    -- try to install the appropriate treesitter parser
		if pcall(vim.treesitter.start, 0) then               -- try to enable highlighting
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- enable folding
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- enable indenting
		end
	end,
})

-- configuration
require("nvim-treesitter-textobjects").setup {
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			['@function.outer'] = 'V',
			['@function.inner'] = 'v',
			['@class.outer'] = 'V',
			['@class.inner'] = 'v',
			['@loop.inner'] = 'v',
			['@loop.outer'] = 'v',
			['@conditional.outer'] = 'v',
			['@conditional.inner'] = 'v',
			['@block.inner'] = 'v',
			['@block.outer'] = 'V',
			['@call.inner'] = 'v',
			['@call.outer'] = 'v',

		},
		-- If you set this to `true` (default is `false`) then any textobject is
		-- extended to include preceding or succeeding whitespace. Succeeding
		-- whitespace has priority in order to act similarly to eg the built-in
		-- `ap`.
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * selection_mode: eg 'v'
		-- and should return true of false
		include_surrounding_whitespace = false,
	},
	move = {
		-- whether to set jumps in the jumplist
		set_jumps = true,
	},
}

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
-- Selection
local ts_select = require "nvim-treesitter-textobjects.select"
-- functions
vim.keymap.set({ "x", "o" }, "af", function()
	ts_select.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	ts_select.select_textobject("@function.inner", "textobjects")
end)
-- classes
vim.keymap.set({ "x", "o" }, "ac", function()
	ts_select.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	ts_select.select_textobject("@class.inner", "textobjects")
end)
-- "blocks"
vim.keymap.set({ "x", "o" }, "ab", function()
	ts_select.select_textobject("@block.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ib", function()
	ts_select.select_textobject("@block.inner", "textobjects")
end)
-- loops
vim.keymap.set({ "x", "o" }, "ao", function()
	ts_select.select_textobject("@loop.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "io", function()
	ts_select.select_textobject("@loop.inner", "textobjects")
end)
-- conditionals
vim.keymap.set({ "x", "o" }, "a/", function()
	ts_select.select_textobject("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "i/", function()
	ts_select.select_textobject("@conditional.inner", "textobjects")
end)
-- calls
vim.keymap.set({ "x", "o" }, "a9", function()
	ts_select.select_textobject("@call.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "i9", function()
	ts_select.select_textobject("@call.inner", "textobjects")
end)


-- Movement
local ts_move = require("nvim-treesitter-textobjects.move")
-- functions
vim.keymap.set({ "n", "x", "o" }, "]f", function()
	ts_move.goto_next_start("@function.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]F", function()
	ts_move.goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[f", function()
	ts_move.goto_previous_start("@function.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[F", function()
	ts_move.goto_previous_end("@function.outer", "textobjects")
end)
-- classes
vim.keymap.set({ "n", "x", "o" }, "]c", function()
	ts_move.goto_next_start("@class.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]C", function()
	ts_move.goto_next_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[c", function()
	ts_move.goto_previous_start("@class.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[C", function()
	ts_move.goto_previous_end("@class.outer", "textobjects")
end)
-- "blocks"
vim.keymap.set({ "n", "x", "o" }, "]b", function()
	ts_move.goto_next_start("@block.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]B", function()
	ts_move.goto_next_end("@block.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[b", function()
	ts_move.goto_previous_start("@block.inner", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[B", function()
	ts_move.goto_previous_end("@block.outer", "textobjects")
end)
-- loops
vim.keymap.set({ "n", "x", "o" }, "]o", function()
	ts_move.goto_next_start({ "@loop.inner", "@loop.inner" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]O", function()
	ts_move.goto_next_end({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[o", function()
	ts_move.goto_previous_start({ "@loop.inner", "@loop.inner" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]O", function()
	ts_move.goto_previous_end({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
-- folds
vim.keymap.set({ "n", "x", "o" }, "]z", function()
	ts_move.goto_next("@fold", "folds")
end)
vim.keymap.set({ "n", "x", "o" }, "[z", function()
	ts_move.goto_previous("@fold", "folds")
end)
-- conditionals
vim.keymap.set({ "n", "x", "o" }, "]/", function()
	ts_move.goto_next("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[/", function()
	ts_move.goto_previous("@conditional.outer", "textobjects")
end)
-- calls
vim.keymap.set({ "n", "x", "o" }, "]9", function()
	ts_move.goto_next("@call.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[9", function()
	ts_move.goto_previous("@call.outer", "textobjects")
end)

-- Repeat movement with ; and ,
local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
