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
	excluded_filetypes = {
	},
	excluded_buftypes = {
	},
	init_switches = {
		whitespace_switch_1 = false,
		whitespace_switch_2 = false,
		whitespace_switch_3 = false,
		whitespace_switch_4 = true,
	},
}
-- whitespace 1: space
-- whitespace 2: multispace
-- whitespace 3: tab
-- whitespace 4: trail

-- # set_status

M.set_status0 = function()
	vim.w.whitespace_switch_1 = nil
	vim.w.whitespace_switch_2 = nil
	vim.w.whitespace_switch_3 = nil
	vim.w.whitespace_switch_4 = nil
end

M.set_status1 = function()
	vim.w.whitespace_switch_1 = M.config.init_switches.whitespace_switch_1
	vim.w.whitespace_switch_2 = M.config.init_switches.whitespace_switch_2
	vim.w.whitespace_switch_3 = M.config.init_switches.whitespace_switch_3
	vim.w.whitespace_switch_4 = M.config.init_switches.whitespace_switch_4
end

M.set_status2 = function()
        if vim.w.whitespace_switch_1 == nil then vim.w.whitespace_switch_1 = M.config.init_switches.whitespace_switch_1 end
        if vim.w.whitespace_switch_2 == nil then vim.w.whitespace_switch_2 = M.config.init_switches.whitespace_switch_2 end
        if vim.w.whitespace_switch_3 == nil then vim.w.whitespace_switch_3 = M.config.init_switches.whitespace_switch_3 end
        if vim.w.whitespace_switch_4 == nil then vim.w.whitespace_switch_4 = M.config.init_switches.whitespace_switch_4 end
end

-- # match

H.insert_p = function()
	local mode = vim.api.nvim_get_mode().mode
	for _, insert_mode in pairs({"i", "R"}) do
		if string.find(mode, insert_mode) then
			return true
		end
	end
	return false
end

M.match_add = function()
	if vim.w.whitespace_switch_1 then
		vim.w.whitespace_id_1 = vim.fn.matchadd('Whitespace1', [[ ]], 1)
	end

	if vim.w.whitespace_switch_2 then
		vim.w.whitespace_id_2 = vim.fn.matchadd('Whitespace2', [[ \{2,}]], 2)
	end

	if vim.w.whitespace_switch_3 then
		vim.w.whitespace_id_3 = vim.fn.matchadd('Whitespace3', [[\t]], 3)
	end

	if vim.w.whitespace_switch_4 then
		if H.insert_p() then
			vim.w.whitespace_id_4 = vim.fn.matchadd('Whitespace4', [[\s\+\%#\@<!$]], 4)
		else
			vim.w.whitespace_id_4 = vim.fn.matchadd('Whitespace4', [[\s\+$]], 4)
		end
	end
end

M.match_del = function()
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_1)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_2)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_3)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_4)
	-- use `pcall` because there is an error if match id is not present
end

M.match_sync = function()
	M.match_del()
	M.match_add()
end

-- # autocmd

H.excluded_filetype_p = function()
	for _, pattern in pairs(M.config.excluded_filetypes) do
		if string.find(vim.bo.filetype, pattern) then
			return true
		end
	end
	return false
end

H.excluded_buftype_p = function()
	for _, pattern in pairs(M.config.excluded_buftypes) do
		if string.find(vim.bo.buftype, pattern) then
			return true
		end
	end
	return false
end

M.create_autocmd = function()
	vim.api.nvim_create_autocmd(
		{
			'BufEnter',
			'WinEnter',
		},
		{
			group = vim.api.nvim_create_augroup('whitespace0', {clear = true}),
			callback = function(arg)
				----------------------------------------------------------------
				vim.schedule(function()
				-- https://github.com/neovim/neovim/issues/29419
				----------------------------------------------------------------
				if H.excluded_filetype_p() or H.excluded_buftype_p() then
					M.set_status0()
					M.match_sync()
					return
				end

				if arg.event == "BufEnter" then
					M.set_status1()
					M.match_sync()
				end

				if arg.event == "WinEnter" then
					M.set_status2()
					M.match_sync()
				end

				vim.api.nvim_create_autocmd(
					{
						'InsertEnter',
						'InsertLeave',
					},
					{
						group = vim.api.nvim_create_augroup('whitespace1', {clear = true}),
						buffer = arg.buf,
						callback = function()
							----------------------------------------------------------------
							vim.schedule(function()
							-- https://github.com/neovim/neovim/issues/31471
							----------------------------------------------------------------
							M.match_sync()
							----------------------------------------------------------------
							end)
							----------------------------------------------------------------
						end,
					})
				----------------------------------------------------------------
				end)
				----------------------------------------------------------------
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
