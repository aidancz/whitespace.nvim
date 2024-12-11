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
		whitespace_switch_4 = false,
		whitespace_switch_5 = false,
		whitespace_switch_6 = false,
		whitespace_switch_7 = false,
		whitespace_switch_8 = false,
		whitespace_switch_9 = true,
	},
}
-- whitespace1: space
-- whitespace2: tab
-- whitespace3: eol
-- whitespace4: multispace
-- whitespace5: multitab
-- whitespace6: multieol
-- whitespace7: lead
-- whitespace8: inner
-- whitespace9: trail

-- # set_status

M.set_status0 = function()
	vim.w.whitespace_switch_1 = nil
	vim.w.whitespace_switch_2 = nil
	vim.w.whitespace_switch_3 = nil
	vim.w.whitespace_switch_4 = nil
	vim.w.whitespace_switch_5 = nil
	vim.w.whitespace_switch_6 = nil
	vim.w.whitespace_switch_7 = nil
	vim.w.whitespace_switch_8 = nil
	vim.w.whitespace_switch_9 = nil
end

M.set_status1 = function()
	vim.w.whitespace_switch_1 = M.config.init_switches.whitespace_switch_1
	vim.w.whitespace_switch_2 = M.config.init_switches.whitespace_switch_2
	vim.w.whitespace_switch_3 = M.config.init_switches.whitespace_switch_3
	vim.w.whitespace_switch_4 = M.config.init_switches.whitespace_switch_4
	vim.w.whitespace_switch_5 = M.config.init_switches.whitespace_switch_5
	vim.w.whitespace_switch_6 = M.config.init_switches.whitespace_switch_6
	vim.w.whitespace_switch_7 = M.config.init_switches.whitespace_switch_7
	vim.w.whitespace_switch_8 = M.config.init_switches.whitespace_switch_8
	vim.w.whitespace_switch_9 = M.config.init_switches.whitespace_switch_9
end

M.set_status2 = function()
        if vim.w.whitespace_switch_1 == nil then vim.w.whitespace_switch_1 = M.config.init_switches.whitespace_switch_1 end
        if vim.w.whitespace_switch_2 == nil then vim.w.whitespace_switch_2 = M.config.init_switches.whitespace_switch_2 end
        if vim.w.whitespace_switch_3 == nil then vim.w.whitespace_switch_3 = M.config.init_switches.whitespace_switch_3 end
        if vim.w.whitespace_switch_4 == nil then vim.w.whitespace_switch_4 = M.config.init_switches.whitespace_switch_4 end
        if vim.w.whitespace_switch_5 == nil then vim.w.whitespace_switch_5 = M.config.init_switches.whitespace_switch_5 end
        if vim.w.whitespace_switch_6 == nil then vim.w.whitespace_switch_6 = M.config.init_switches.whitespace_switch_6 end
        if vim.w.whitespace_switch_7 == nil then vim.w.whitespace_switch_7 = M.config.init_switches.whitespace_switch_7 end
        if vim.w.whitespace_switch_8 == nil then vim.w.whitespace_switch_8 = M.config.init_switches.whitespace_switch_8 end
        if vim.w.whitespace_switch_9 == nil then vim.w.whitespace_switch_9 = M.config.init_switches.whitespace_switch_9 end
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
		vim.w.whitespace_id_2 = vim.fn.matchadd('Whitespace2', [[\t]], 2)
	end

	if vim.w.whitespace_switch_3 then
		vim.w.whitespace_id_3 = vim.fn.matchadd('Whitespace3', [[\n]], 3)
	end

	if vim.w.whitespace_switch_4 then
		vim.w.whitespace_id_4 = vim.fn.matchadd('Whitespace4', [[ \{2,}]], 4)
	end

	if vim.w.whitespace_switch_5 then
		vim.w.whitespace_id_5 = vim.fn.matchadd('Whitespace5', [[\t\{2,}]], 5)
	end

	if vim.w.whitespace_switch_6 then
		vim.w.whitespace_id_6 = vim.fn.matchadd('Whitespace6', [[\n\{2,}]], 6)
	end

	if vim.w.whitespace_switch_7 then
		vim.w.whitespace_id_7 = vim.fn.matchadd('Whitespace7', [[^\s\+]], 7)
	end

	if vim.w.whitespace_switch_8 then
		vim.w.whitespace_id_8 = vim.fn.matchadd('Whitespace8', [[\S\zs\s\+\ze\S]], 8)
	end

	if vim.w.whitespace_switch_9 then
		if H.insert_p() then
			vim.w.whitespace_id_9 = vim.fn.matchadd('Whitespace9', [[\s\+\%#\@<!$]], 9)
		else
			vim.w.whitespace_id_9 = vim.fn.matchadd('Whitespace9', [[\s\+$]], 9)
		end
	end

end

M.match_del = function()
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_1)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_2)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_3)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_4)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_5)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_6)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_7)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_8)
	pcall(vim.fn.matchdelete, vim.w.whitespace_id_9)
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
	vim.api.nvim_set_hl(0, 'Whitespace1', {ctermbg = 4, bg = "#0000ff"})
	vim.api.nvim_set_hl(0, 'Whitespace2', {ctermbg = 3, bg = "#ffff00"})
	vim.api.nvim_set_hl(0, 'Whitespace3', {ctermbg = 2, bg = "#00ff00"})
	vim.api.nvim_set_hl(0, 'Whitespace4', {ctermbg = 4, bg = "#0000ff"})
	vim.api.nvim_set_hl(0, 'Whitespace5', {ctermbg = 3, bg = "#ffff00"})
	vim.api.nvim_set_hl(0, 'Whitespace6', {ctermbg = 2, bg = "#00ff00"})
	vim.api.nvim_set_hl(0, 'Whitespace7', {ctermbg = 5, bg = "#ff00ff"})
	vim.api.nvim_set_hl(0, 'Whitespace8', {ctermbg = 6, bg = "#00ffff"})
	vim.api.nvim_set_hl(0, 'Whitespace9', {ctermbg = 1, bg = "#ff0000"})
end

-- # return
return M
