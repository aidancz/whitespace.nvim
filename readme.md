whitespace.nvim - highlight whitespace on demand

# demo

![](assets/demo.gif)

provide 4 types of whitespace, highlight them on demand

- whitespace1: space
- whitespace2: multispace
- whitespace3: tab
- whitespace4: trail (won't be highlighted if your cursor is placed at the end of it in insert mode, as shown in the demo)

# setup

## setup example 1:

```
require("whitespace").setup()
```

this uses default settings, which is equivalent to:

```
require("whitespace").setup({
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
})
vim.api.nvim_set_hl(0, 'Whitespace1', {link = 'Visual'})
vim.api.nvim_set_hl(0, 'Whitespace2', {link = 'Visual'})
vim.api.nvim_set_hl(0, 'Whitespace3', {link = 'CursorLine'})
vim.api.nvim_set_hl(0, 'Whitespace4', {link = 'Error'})
```

the `init_switches` controls whether to highlight specific type of whitespace when entering buffer  
for example, the above setup only highlight whitespace4 (which is trail) when entering buffer  

the highlight group of `whitespace1` is `Whitespace1`  
the highlight group of `whitespace2` is `Whitespace2`  
the highlight group of `whitespace3` is `Whitespace3`  
the highlight group of `whitespace4` is `Whitespace4`  

## setup example 2:

```
require("whitespace").setup({
	excluded_filetypes = {
		"c",
		"lua",
	},
	excluded_buftypes = {
		".+",
	},
})
```

this highlights the whitespace, but only when:
1. the `filetype` is neither `c` nor `lua`
2. the `buftype` does not match lua pattern `.+`, which means the `buftype` must be an empty string

## setup example 3:

```
require("whitespace").setup()

local toggle = function()
	vim.w.whitespace_switch_1 = not vim.w.whitespace_switch_1
	vim.w.whitespace_switch_2 = not vim.w.whitespace_switch_2
	vim.w.whitespace_switch_3 = not vim.w.whitespace_switch_3
	require("whitespace").match_sync()
end
vim.keymap.set({"n", "x", "i"}, "<f11>", toggle)
```

this defines a function named `toggle`, which toggles the display of whitespace1~3

## setup example 4:

if you are using `lazy.nvim`:

```
{
	"aidancz/whitespace.nvim",
	lazy = false,
	config = function()
		require("whitespace").setup()
	end,
}
```
