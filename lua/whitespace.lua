-- https://vim.fandom.com/wiki/Highlight_unwanted_spaces
-- https://gist.github.com/pironim/3722006
-- https://github.com/echasnovski/mini.trailspace/blob/main/lua/mini/trailspace.lua

-- test regexp
--[=[
vim.api.nvim_create_autocmd(
	{'CursorMoved', 'CursorMovedI'}, {
	callback = function()
		vim.fn.matchadd('test', [[\s\+\%#\@<!$]])
	end,
	})
vim.api.nvim_set_hl(0, 'test', {link = 'Error'})
--]=]

-- # module & help

local M = {}
local H = {}

-- # setup

M.setup = function(config)
	M.config = vim.tbl_deep_extend('force', M.config, config or {})
	M.create_autocmd()
	M.create_default_hl()
end

-- # config

M.config = {
	only_in_normal_buffers = true,
	set_init_switches = function()
		vim.b.whitespace_switch_1 = false
		vim.b.whitespace_switch_2 = false
		vim.b.whitespace_switch_3 = false
		vim.b.whitespace_switch_4 = true
	end,
}
-- whitespace 1: space
-- whitespace 2: multispace
-- whitespace 3: tab
-- whitespace 4: trail

-- # set_init_status

M.set_init_status = function()
	M.config.set_init_switches()

	vim.b.whitespace_id_1 = nil
	vim.b.whitespace_id_2 = nil
	vim.b.whitespace_id_3 = nil
	vim.b.whitespace_id_4 = nil

	if vim.api.nvim_get_mode().mode == 'i' then
		vim.b.whitespace_insert = true
	else
		vim.b.whitespace_insert = false
	end
end

-- # match

M.match_add = function()
	if vim.b.whitespace_switch_1 then
		vim.b.whitespace_id_1 = vim.fn.matchadd('Whitespace1', [[ ]], 1)
	end

	if vim.b.whitespace_switch_2 then
		vim.b.whitespace_id_2 = vim.fn.matchadd('Whitespace2', [[ \{2,}]], 2)
	end

	if vim.b.whitespace_switch_3 then
		vim.b.whitespace_id_3 = vim.fn.matchadd('Whitespace3', [[\t]], 3)
	end

	if vim.b.whitespace_switch_4 then
		if vim.b.whitespace_insert then
			vim.b.whitespace_id_4 = vim.fn.matchadd('Whitespace4', [[\s\+\%#\@<!$]], 4)
		else
			vim.b.whitespace_id_4 = vim.fn.matchadd('Whitespace4', [[\s\+$]], 4)
		end
	end
end

M.match_del = function()
	pcall(vim.fn.matchdelete, vim.b.whitespace_id_1)
	pcall(vim.fn.matchdelete, vim.b.whitespace_id_2)
	pcall(vim.fn.matchdelete, vim.b.whitespace_id_3)
	pcall(vim.fn.matchdelete, vim.b.whitespace_id_4)
	-- use `pcall` because there is an error if match id is not present
end

M.match_sync = function()
	M.match_del()
	M.match_add()
end

-- # autocmd

H.buffer_normal_p = function()
	if vim.bo[0].buftype == '' then
		return true
	else
		return false
	end
end

M.create_autocmd = function()
	local whitespace_augroup = vim.api.nvim_create_augroup('whitespace', {clear = true})

	vim.api.nvim_create_autocmd(
		{
			'WinEnter',
			'BufEnter',
		},
		{
			group = whitespace_augroup,
			callback = function()
				local a = M.config.only_in_normal_buffers
				local b = H.buffer_normal_p()
				if a and (not b) then
					return
				end



				M.set_init_status()
				M.match_sync()



				vim.api.nvim_create_autocmd(
					{
						'InsertEnter',
					},
					{
						group = whitespace_augroup,
						callback = function()
							vim.b.whitespace_insert = true
							M.match_sync()
						end,
					})

				vim.api.nvim_create_autocmd(
					{
						'InsertLeave',
					},
					{
						group = whitespace_augroup,
						callback = function()
							vim.b.whitespace_insert = false
							M.match_sync()
						end,
					})
			end,
		})
end

-- # highlight

M.create_default_hl = function()
	vim.api.nvim_set_hl(0, 'Whitespace1', {link = 'Visual'})
	vim.api.nvim_set_hl(0, 'Whitespace2', {link = 'Visual'})
	vim.api.nvim_set_hl(0, 'Whitespace3', {link = 'CursorLine'})
	vim.api.nvim_set_hl(0, 'Whitespace4', {link = 'Error'})
end

-- # return
return M
