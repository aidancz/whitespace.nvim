whitespace.nvim - highlight whitespace on demand

# demo

![](assets/demo.gif)

provide 9 types of whitespace, highlight them on demand

- whitespace1: space
- whitespace2: tab
- whitespace3: eol
- whitespace4: multispace
- whitespace5: multitab
- whitespace6: multieol
- whitespace7: lead
- whitespace8: inner
- whitespace9: trail (won't be highlighted if your cursor is placed at the end of it in insert mode, as shown in the demo)

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
		whitespace_switch_4 = false,
		whitespace_switch_5 = false,
		whitespace_switch_6 = false,
		whitespace_switch_7 = false,
		whitespace_switch_8 = false,
		whitespace_switch_9 = true,
	},
})
vim.api.nvim_set_hl(0, 'Whitespace1', {ctermbg = 4, bg = "#0000ff"})
vim.api.nvim_set_hl(0, 'Whitespace2', {ctermbg = 3, bg = "#ffff00"})
vim.api.nvim_set_hl(0, 'Whitespace3', {ctermbg = 2, bg = "#00ff00"})
vim.api.nvim_set_hl(0, 'Whitespace4', {ctermbg = 4, bg = "#0000ff"})
vim.api.nvim_set_hl(0, 'Whitespace5', {ctermbg = 3, bg = "#ffff00"})
vim.api.nvim_set_hl(0, 'Whitespace6', {ctermbg = 2, bg = "#00ff00"})
vim.api.nvim_set_hl(0, 'Whitespace7', {ctermbg = 5, bg = "#ff00ff"})
vim.api.nvim_set_hl(0, 'Whitespace8', {ctermbg = 6, bg = "#00ffff"})
vim.api.nvim_set_hl(0, 'Whitespace9', {ctermbg = 1, bg = "#ff0000"})
```

the `init_switches` controls whether to highlight specific type of whitespace when entering buffer  
for example, the above setup only highlight whitespace9 (which is trail) when entering buffer  

the highlight group of `whitespace1` is `Whitespace1`  
the highlight group of `whitespace2` is `Whitespace2`  
...  
the highlight group of `whitespace9` is `Whitespace9`  

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

# test

you can use this sample file to test:

http://xahlee.info/emacs/emacs/emacs_init_whitespace_mode.html

```


above is beginning of file repeated newline

 beginning single space
ending single space 
    beginning repeated spaces
        beginning repeated spaces
ending repeated spaces    
ending repeated spaces        
	beginning single tab
ending single tab	
			beginning repeated tabs
ending repeated tabs			
 	beginning space tab
ending space tab 	
  	beginning space space tab
ending space space tab  	
	 beginning tab space
ending tab space	 
	  beginning tab space space
ending tab space space	  

123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 
this is a long line. what's “long” is determined by fill-column, not by window width.


 long long long long long long long long long long

LongLineNoWhiteSpacettttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt

                  this is a long line with beginning and ending repeated spaces long long long long                


following is end of file repeated newline


```
