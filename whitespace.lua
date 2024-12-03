-- # module & help

local M = {}
local H = {}

-- # setup

M.setup = function(userconfig)
	M.config = H.setup_config(M.config, userconfig or {})
	M.create_autocommands()
end

-- # config

M.config = {
	only_in_normal_buffers = true,
}

H.setup_config = function(defaultconfig, userconfig)
	vim.validate({
		userconfig             = {userconfig,                        'table',   false},
		only_in_normal_buffers = {userconfig.only_in_normal_buffers, 'boolean', true}
		})
	mergedconfig = vim.tbl_deep_extend('force', defaultconfig, userconfig)
	return mergedconfig
end

H.get_config = function(config)
	return vim.tbl_deep_extend('force', M.config, vim.b.nofrils_whitespace_config or {}, config or {})
end

-- # autocmd

M.create_autocommands = function()
	local gr = vim.api.nvim_create_augroup('nofrils_whitespace', {clear = true})
	local au = function(event, pattern, callback)
		vim.api.nvim_create_autocmd(
			event,
			{
				group = gr,
				pattern = pattern,
				callback = callback,
			}
		)
	end

	au('ColorScheme', '*', M.create_default_hl)

	au({'WinEnter', 'BufEnter'}, '*',
		function()
			local a = H.get_config().only_in_normal_buffers
			local b = H.is_buffer_normal()
			if (not a) or (a and b) then
				M.highlight()
			end
		end)

	au({'WinLeave', 'BufLeave'}, '*', M.unhighlight)

	au('InsertEnter', '*', function() M.highlight({insert = true}) end)

	au('InsertLeave', '*', M.highlight)

	if H.get_config().only_in_normal_buffers then
		au('OptionSet', 'buftype',
			function()
				if vim.v.option_new == '' then
					M.highlight()
				else
					M.unhighlight()
				end
			end)
	end
end

M.create_default_hl = function()
	vim.api.nvim_set_hl(0, 'nofrils-sp',     {link = 'nofrils-blue-bg'})
	vim.api.nvim_set_hl(0, 'nofrils-sp-mul', {link = 'nofrils-yellow-bg'})
	vim.api.nvim_set_hl(0, 'nofrils-ht',     {link = 'nofrils-green-bg'})
	vim.api.nvim_set_hl(0, 'nofrils-trail',  {link = 'nofrils-red-bg'})
end

M.unhighlight = function()
	pcall(vim.fn.matchdelete, vim.b.nofrils_sp)
	pcall(vim.fn.matchdelete, vim.b.nofrils_sp_mul)
	pcall(vim.fn.matchdelete, vim.b.nofrils_ht)
	pcall(vim.fn.matchdelete, vim.b.nofrils_trail)
	-- use `pcall` because there is an error if match id is not present
end

M.highlight = function(config)
	M.unhighlight()

	if vim.b.nofrils_sp_enable then
		vim.b.nofrils_sp = vim.fn.matchadd('nofrils-sp', [[ ]], 1)
	end

	if vim.b.nofrils_sp_mul_enable then
		vim.b.nofrils_sp_mul = vim.fn.matchadd('nofrils-sp-mul', [[ \{2,}]], 2)
	end

	if vim.b.nofrils_ht_enable then
		vim.b.nofrils_ht = vim.fn.matchadd('nofrils-ht', [[\t]], 3)
	end

	if vim.b.nofrils_trail_enable then
		if config and config.insert then
			vim.b.nofrils_trail = vim.fn.matchadd('nofrils-trail', [[\s\+\%#\@<!$]], 4)
		else
			vim.b.nofrils_trail = vim.fn.matchadd('nofrils-trail', [[\s\+$]], 4)
		end
	end
end

H.is_buffer_normal = function(buf_id) return vim.bo[buf_id or 0].buftype == '' end



M.toggle = function()
	vim.b.nofrils_sp_enable     = not vim.b.nofrils_sp_enable
	vim.b.nofrils_sp_mul_enable = not vim.b.nofrils_sp_mul_enable
	vim.b.nofrils_ht_enable     = not vim.b.nofrils_ht_enable
	M.highlight()
end



vim.b.nofrils_sp_enable     = false
vim.b.nofrils_sp_mul_enable = false
vim.b.nofrils_ht_enable     = false
vim.b.nofrils_trail_enable  = true

vim.keymap.set({"n", "x", "i"}, "<f11>", M.toggle)

M.setup()
