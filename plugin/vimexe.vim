"	VIM SETTINGS: {{{3
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
"let g:VimExe_runpath_python = g:VimExe_command_str_prefix . "$HOME/.pyenv/shims/python3"
let g:VimExe_runpath_python = g:VimExe_command_str_prefix . "/usr/local/bin/python3"

let g:VimExe_ft_bash = "sh"
let g:VimExe_runpath_shell = g:VimExe_command_str_prefix . "/bin/bash"

let g:VimExe_ft_vimscript = "vim"
let g:VimExe_runpath_vimscript = ':source %'

"let g:VimExe_ft_zsh_run = [ "zsh", g:VimExe_command_str_prefix . "/usr/local/bin/zsh" ]
let g:VimExe_ft_zsh_run = [ "zsh", g:VimExe_command_str_prefix . $bin_zsh ]
"let g:VimExe_ft_perl_run = [ "perl", g:VimExe_command_str_prefix . "/usr/local/bin/perl" ]
let g:VimExe_ft_perl_run = [ "perl", g:VimExe_command_str_prefix . $bin_perl ]

"	TODO: 2021-05-18T20:04:00AEST This is f------ fugly as f--- -> clean approach (with filetypes, run commands read from config file?)

"	TODO: 2021-05-18T18:36:44AEST running a single C source (which is not actually *implemented* here) (And is sort of pointless in anycase - beyond the 'interactive' example?)
"	2021-05-18T20:02:43AEST Save source to temp file, compile and run that?

let g:VimExe_ft_c = "c"
let g:VimExe_ft_cpp = "cpp"

"let g:VimExe_runpath_gcc = "gcc"


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
	elseif (current_filetype == g:VimExe_ft_c)
		"let runcmd = g:VimExe_runpath_gcc 
		"echoerr func_name . ": Ongoing implemention of Exe for C source"

		"	TODO: 2021-05-19T19:53:34AEST Save file, so that current buffer is what is built
		"let runcmd = ":w<CR>"
		"execute runcmd

		let runcmd = 'gcc ' . expand('%:t') . ' -o a.vim.out; ./a.vim.out' 
		let result = system(runcmd)
		echo "runcmd=(" . runcmd . ")"
		echo "========================================"
		echo result
		echo "========================================"
		return

	elseif (current_filetype == g:VimExe_ft_cpp)

		let runcmd = 'g++ -std=c++17 ' . expand('%:t') . ' -o a.vim.out; ./a.vim.out' 
		let result = system(runcmd)
		echo "runcmd=(" . runcmd . ")"
		echo "========================================"
		echo result
		echo "========================================"
		return

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

	" (2019-11-24)-(1927-01) Prompt the user for input, to prevent the output window being closed pre-maturely.
	call inputsave()
	let value = input("Press Enter to Continue.")
	call inputrestore()
endfunction
"	}}}

command! Exe execute "call VimExe()"
command! ExeClipboard execute "call VimExe(1)"

"	}}}1 

