"	VIM SETTINGS: {{{3
"	VIM: let g:mldvp_filecmd_open_tagbar=0 g:mldvp_filecmd_NavHeadings="" g:mldvp_filecmd_NavSubHeadings="" g:mldvp_filecmd_NavDTS=0 g:mldvp_filecmd_vimgpgSave_gotoRecent=0
"	vim: set tabstop=4 modeline modelines=10 foldmethod=marker:
"	vim: set foldlevel=2 foldcolumn=3: 
"	}}}1
"	{{{2

let g:VimExe_loaded = 1

let g:VimExe_outputToClipboard_default = 0
let g:VimExe_runpath_vimscript_clipboard = 'redir @+ | :source % | redir END'

let g:VimExe_command_str_prefix = ":w !"

"	TODO: 2020-11-29T11:54:03AEDT standard(ised) declaration of filetypes and runpaths -> (instead of if-else, list which can be itterated over)

let g:VimExe_ft_python = "python"
let g:VimExe_runpath_python = g:VimExe_command_str_prefix . "$HOME/.pyenv/shims/python3"

let g:VimExe_ft_bash = "sh"
let g:VimExe_runpath_shell = g:VimExe_command_str_prefix . "/bin/bash"

let g:VimExe_ft_vimscript = "vim"
let g:VimExe_runpath_vimscript = ':source %'

let g:VimExe_ft_zsh_run = [ "zsh", g:VimExe_command_str_prefix . "/bin/zsh" ]
let g:VimExe_ft_perl_run = [ "perl", g:VimExe_command_str_prefix . "/usr/bin/perl" ]

function! g:VimExe(...)
"	{{{
	"let func_name = g:VimExe_CallerFuncName()
	let func_name = "VimExe"
	let func_printdebug = 1
	let current_filetype = &ft	
	let command_str = g:VimExe_command_str_prefix 
	let put_output_to_clipboard = get(a:, 1, g:VimExe_outputToClipboard_default)
	let runcmd = ""

	"	TODO: 2020-11-19T18:49:54AEDT store previous working directory, then return after completion of function?
	"	Update: 2020-11-19T18:49:35AEDT navigate to directory containing file
	cd %:h

	let found_filetype_flag = 0
	if (current_filetype == g:VimExe_ft_python)
		let runcmd=g:VimExe_runpath_python
		let found_filetype_flag = 1
	elseif (current_filetype == g:VimExe_ft_bash)
		let runcmd = g:VimExe_runpath_shell
		let found_filetype_flag = 1
	elseif (current_filetype == g:VimExe_ft_perl_run[0])
		let runcmd = g:VimExe_ft_perl_run[1]
		let found_filetype_flag = 1
	elseif (current_filetype == g:VimExe_ft_vimscript)
		"let runcmd = g:VimExe_runpath_vimscript
		"let found_filetype_flag = 1
		if (put_output_to_clipboard == 0)
			execute g:VimExe_runpath_vimscript
		else
			execute g:VimExe_runpath_vimscript_clipboard
		endif
		"return
	elseif (current_filetype == g:VimExe_ft_zsh_run[0])
		let runcmd = g:VimExe_ft_zsh_run[1]
		let found_filetype_flag = 1
	else
		let message_str = func_name . ": error, filetype not found"
		echo message_str
		return
	endif

	"	execute does not return anything. Therefore, to get output into the clipboard, we pipe output to pbcopy, then run pbpaste so said output gets printed to window
	if (put_output_to_clipboard == 1)
		let runcmd = runcmd . " | pbcopy ; pbpaste "
	endif

	" (2019-11-27)-(1636-54) Print Output:
	echo "runcmd=(" . runcmd . ")"
	echo "========================================"
	execute runcmd
	echo "========================================"
	echo ""

	if (func_printdebug == 1)
		echo printf("runcmd=(%s)\n", runcmd)
	endif

	" (2019-11-24)-(1927-01) Prompt the user for input, to prevent the output window being closed pre-maturely.
	call inputsave()
	let value = input("Press Enter to Continue.")
	call inputrestore()
endfunction
"	}}}

command! Exe execute "call VimExe()"
command! ExeClipboard execute "call VimExe(1)"

"	}}}1 

