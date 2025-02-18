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
	definition = {
		{
			id = "trail",
			pattern = [[\s\+$]],
			pattern_insert = [[\s\+\%#\@<!$]],
			default_display = true,
		},
	},
}

-- # set_status

M.set_status0 = function()
	for _, i in ipairs(M.config.definition) do
		(load(string.format("vim.w.%s = nil", i.id)))()
	end
end

M.set_status1 = function()
	for _, i in ipairs(M.config.definition) do
		(load(string.format("vim.w.%s = %s", i.id, i.default_display)))()
	end
end

M.set_status2 = function()
	for _, i in ipairs(M.config.definition) do
		if (load(string.format("return vim.w.%s == nil", i.id)))() then
			(load(string.format("vim.w.%s = %s", i.id, i.default_display)))()
		end
	end
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
	for _, i in ipairs(M.config.definition) do
		if (load(string.format("return vim.w.%s", i.id)))() then
			if i.pattern_insert and H.insert_p() then
				(load(string.format("vim.w.%s_matchid = %s", i.id, vim.fn.matchadd(i.id, i.pattern_insert))))()
			else
				(load(string.format("vim.w.%s_matchid = %s", i.id, vim.fn.matchadd(i.id, i.pattern))))()
			end
		end
	end
end

M.match_del = function()
	for _, i in ipairs(M.config.definition) do
		(load(string.format("pcall(vim.fn.matchdelete, vim.w.%s_matchid)", i.id)))()
	end
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
						buffer = 0,
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
	for _, i in ipairs(M.config.definition) do
		(load(string.format("vim.api.nvim_set_hl(0, '%s', {ctermbg = 1, bg = '#ff0000'})", i.id)))()
	end
end

-- # return
return M
